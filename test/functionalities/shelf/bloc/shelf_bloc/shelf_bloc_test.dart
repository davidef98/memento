import 'package:bloc_test/bloc_test.dart';
import 'package:books_api/books_api.dart';
import 'package:books_repository/books_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf_api/shelf_api.dart';

import 'package:memento/functionalities/shelf/bloc/shelf_bloc/shelf_bloc.dart';
import 'package:memento/functionalities/shelf/models/library_filter.dart';

class MockBooksRepository extends Mock implements BooksRepository {}

class FakeBookGeneric extends Fake implements BookGeneric {}

void main() {
  group('ShelfBloc', () {
    late BooksRepository booksRepository;

    const mockBookGeneric = BookGeneric(
      key: '/works/OL1168083W',
      title: '1984',
    );

    final mockSavedBook = SavedBook(
      id: '/works/OL1168083W',
      title: '1984',
      savedAt: DateTime(2025),
    );

    setUpAll(() {
      registerFallbackValue(LibrarySortOrder.savedAtDescending);
      registerFallbackValue(FakeBookGeneric());
    });

    setUp(() {
      booksRepository = MockBooksRepository();
    });

    ShelfBloc buildBloc() {
      return ShelfBloc(booksRepository: booksRepository);
    }

    group('constructor', () {
      test('works properly', () {
        expect(buildBloc, returnsNormally);
      });

      test('has correct initial state', () {
        expect(
          buildBloc().state,
          equals(const ShelfState()),
        );
      });
    });

    group('ShelfSubscriptionRequested', () {
      blocTest<ShelfBloc, ShelfState>(
        'emits [loading, success] with saved books when stream emits data',
        setUp: () {
          when(
                () => booksRepository.getSavedBooks(
              order: any(named: 'order'),
            ),
          ).thenAnswer((_) => Stream.value([mockSavedBook]));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const ShelfSubscriptionRequested()),
        expect: () => [
          const ShelfState(status: ShelfStatus.loading),
          ShelfState(
            status: ShelfStatus.success,
            shelfBooks: [mockSavedBook],
          ),
        ],
        verify: (_) {
          verify(
                () => booksRepository.getSavedBooks(
              order: LibrarySortOrder.savedAtDescending,
            ),
          ).called(1);
        },
      );

      blocTest<ShelfBloc, ShelfState>(
        'emits [loading, failure] when stream emits error',
        setUp: () {
          when(
                () => booksRepository.getSavedBooks(
              order: any(named: 'order'),
            ),
          ).thenAnswer((_) => Stream.error(Exception('Stream error')));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const ShelfSubscriptionRequested()),
        expect: () => const [
          ShelfState(status: ShelfStatus.loading),
          ShelfState(status: ShelfStatus.failure),
        ],
      );
    });

    group('SortShelfOrderChanged', () {
      blocTest<ShelfBloc, ShelfState>(
        'does nothing when newSortOrder is equal to current state.orderBy',
        seed: () => const ShelfState(
          orderBy: LibrarySortOrder.savedAtAscending,
        ),
        build: buildBloc,
        act: (bloc) => bloc.add(
          const SortShelfOrderChanged(LibrarySortOrder.savedAtAscending),
        ),
        expect: () => <ShelfState>[],
        verify: (_) {
          verifyNever(
                () => booksRepository.getSavedBooks(
              order: any(named: 'order'),
            ),
          );
        },
      );

      blocTest<ShelfBloc, ShelfState>(
        'emits state with updated orderBy and triggers ShelfSubscriptionRequested when sort order changes',
        setUp: () {
          when(
                () => booksRepository.getSavedBooks(
              order: any(named: 'order'),
            ),
          ).thenAnswer((_) => Stream.value([mockSavedBook]));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(
          const SortShelfOrderChanged(LibrarySortOrder.savedAtAscending),
        ),
        expect: () => [
          const ShelfState(
            orderBy: LibrarySortOrder.savedAtAscending,
          ),
          const ShelfState(
            status: ShelfStatus.loading,
            orderBy: LibrarySortOrder.savedAtAscending,
          ),
          ShelfState(
            status: ShelfStatus.success,
            shelfBooks: [mockSavedBook],
            orderBy: LibrarySortOrder.savedAtAscending,
          ),
        ],
        verify: (_) {
          verify(
                () => booksRepository.getSavedBooks(
              order: LibrarySortOrder.savedAtAscending,
            ),
          ).called(1);
        },
      );
    });

    group('ShelfFilterChanged', () {
      blocTest<ShelfBloc, ShelfState>(
        'emits new state with updated filter',
        seed: () => const ShelfState(filter: LibraryFilter.all),
        build: buildBloc,
        act: (bloc) => bloc.add(const ShelfFilterChanged(LibraryFilter.inProgress)),
        expect: () => const [
          ShelfState(filter: LibraryFilter.inProgress),
        ],
      );
    });

    group('AddBook', () {
      blocTest<ShelfBloc, ShelfState>(
        'calls repository.addBook successfully without emitting new state',
        setUp: () {
          when(() => booksRepository.addBook(any())).thenAnswer((_) async {});
        },
        build: buildBloc,
        act: (bloc) => bloc.add(AddBook(mockBookGeneric)),
        expect: () => <ShelfState>[],
        verify: (_) {
          verify(() => booksRepository.addBook(mockBookGeneric)).called(1);
        },
      );

      blocTest<ShelfBloc, ShelfState>(
        'emits status alreadyInLibraryFailure when BookAlreadyInLibraryException occurs',
        setUp: () {
          when(() => booksRepository.addBook(any()))
              .thenThrow(const BookAlreadyInLibraryException('/works/OL1168083W'));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(AddBook(mockBookGeneric)),
        expect: () => const [
          ShelfState(status: ShelfStatus.alreadyInLibraryFailure),
        ],
      );

      blocTest<ShelfBloc, ShelfState>(
        'emits status addingFailure when generic Exception occurs',
        setUp: () {
          when(() => booksRepository.addBook(any())).thenThrow(Exception('Add failed'));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(AddBook(mockBookGeneric)),
        expect: () => const [
          ShelfState(status: ShelfStatus.addingFailure),
        ],
      );
    });

    group('DeleteSavedBook', () {
      const bookId = '/works/OL1168083W';

      blocTest<ShelfBloc, ShelfState>(
        'calls repository.removeBook successfully without emitting new state',
        setUp: () {
          when(() => booksRepository.removeBook(any())).thenAnswer((_) async {});
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const DeleteSavedBook(bookId)),
        expect: () => <ShelfState>[],
        verify: (_) {
          verify(() => booksRepository.removeBook(bookId)).called(1);
        },
      );

      blocTest<ShelfBloc, ShelfState>(
        'emits status bookNotFoundFailure when BookNotFoundException occurs',
        setUp: () {
          when(() => booksRepository.removeBook(any()))
              .thenThrow(const BookNotFoundException(bookId));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const DeleteSavedBook(bookId)),
        expect: () => const [
          ShelfState(status: ShelfStatus.bookNotFoundFailure),
        ],
      );

      blocTest<ShelfBloc, ShelfState>(
        'emits status removingFailure when generic Exception occurs',
        setUp: () {
          when(() => booksRepository.removeBook(any())).thenThrow(Exception('Remove failed'));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const DeleteSavedBook(bookId)),
        expect: () => const [
          ShelfState(status: ShelfStatus.removingFailure),
        ],
      );
    });
  });
}