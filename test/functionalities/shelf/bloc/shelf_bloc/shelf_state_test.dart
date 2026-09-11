// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_api/shelf_api.dart';

import 'package:memento/functionalities/shelf/bloc/shelf_bloc/shelf_bloc.dart';
import 'package:memento/functionalities/shelf/models/library_filter.dart';

void main() {
  group('ShelfState', () {
    final mockSavedBook = SavedBook(
      id: '/works/OL1168083W',
      title: '1984',
      savedAt: DateTime(2025),
    );

    ShelfState createSubject({
      ShelfStatus status = ShelfStatus.initial,
      List<SavedBook> shelfBooks = const [],
      LibrarySortOrder orderBy = LibrarySortOrder.savedAtDescending,
      LibraryFilter filter = LibraryFilter.all,
    }) {
      return ShelfState(
        status: status,
        shelfBooks: shelfBooks,
        orderBy: orderBy,
        filter: filter,
      );
    }

    test('supports value equality', () {
      expect(
        createSubject(),
        equals(createSubject()),
      );
    });

    test('props are correct', () {
      expect(
        createSubject(
          status: ShelfStatus.success,
          shelfBooks: [mockSavedBook],
          orderBy: LibrarySortOrder.savedAtAscending,
          filter: LibraryFilter.all,
        ).props,
        equals(<Object?>[
          ShelfStatus.success,
          [mockSavedBook],
          LibrarySortOrder.savedAtAscending,
          LibraryFilter.all,
        ]),
      );
    });

    group('ShelfStatusX', () {
      test('returns correct value for isInitial', () {
        final state = createSubject(status: ShelfStatus.initial);
        expect(state.status.isInitial, isTrue);
        expect(state.status.isLoading, isFalse);
        expect(state.status.isFailure, isFalse);
        expect(state.status.isAlreadyInLibraryFailure, isFalse);
        expect(state.status.isBookNotFoundFailure, isFalse);
        expect(state.status.isAddingFailure, isFalse);
        expect(state.status.isRemovingFailure, isFalse);
        expect(state.status.isSuccess, isFalse);
      });

      test('returns correct value for isLoading', () {
        final state = createSubject(status: ShelfStatus.loading);
        expect(state.status.isLoading, isTrue);
        expect(state.status.isSuccess, isFalse);
      });

      test('returns correct value for isFailure', () {
        final state = createSubject(status: ShelfStatus.failure);
        expect(state.status.isFailure, isTrue);
        expect(state.status.isSuccess, isFalse);
      });

      test('returns correct value for isAlreadyInLibraryFailure', () {
        final state = createSubject(status: ShelfStatus.alreadyInLibraryFailure);
        expect(state.status.isAlreadyInLibraryFailure, isTrue);
        expect(state.status.isSuccess, isTrue);
      });

      test('returns correct value for isBookNotFoundFailure', () {
        final state = createSubject(status: ShelfStatus.bookNotFoundFailure);
        expect(state.status.isBookNotFoundFailure, isTrue);
        expect(state.status.isSuccess, isTrue);
      });

      test('returns correct value for isAddingFailure', () {
        final state = createSubject(status: ShelfStatus.addingFailure);
        expect(state.status.isAddingFailure, isTrue);
        expect(state.status.isSuccess, isTrue);
      });

      test('returns correct value for isRemovingFailure', () {
        final state = createSubject(status: ShelfStatus.removingFailure);
        expect(state.status.isRemovingFailure, isTrue);
        expect(state.status.isSuccess, isTrue);
      });

      test('isSuccess evaluates to true for non-critical operation errors', () {
        expect(createSubject(status: ShelfStatus.success).status.isSuccess, isTrue);
        expect(createSubject(status: ShelfStatus.addingFailure).status.isSuccess, isTrue);
        expect(createSubject(status: ShelfStatus.alreadyInLibraryFailure).status.isSuccess, isTrue);
        expect(createSubject(status: ShelfStatus.removingFailure).status.isSuccess, isTrue);
        expect(createSubject(status: ShelfStatus.bookNotFoundFailure).status.isSuccess, isTrue);

        expect(createSubject(status: ShelfStatus.initial).status.isSuccess, isFalse);
        expect(createSubject(status: ShelfStatus.loading).status.isSuccess, isFalse);
        expect(createSubject(status: ShelfStatus.failure).status.isSuccess, isFalse);
      });
    });

    group('copyWith', () {
      test('returns the same object if no arguments are provided', () {
        expect(
          createSubject().copyWith(),
          equals(createSubject()),
        );
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
          createSubject().copyWith(
            status: null,
            shelfBooks: null,
            orderBy: null,
            filter: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            status: ShelfStatus.success,
            shelfBooks: [mockSavedBook],
            orderBy: LibrarySortOrder.savedAtAscending,
            filter: LibraryFilter.inProgress,
          ),
          equals(
            createSubject(
              status: ShelfStatus.success,
              shelfBooks: [mockSavedBook],
              orderBy: LibrarySortOrder.savedAtAscending,
              filter: LibraryFilter.inProgress,
            ),
          ),
        );
      });
    });

    group('filteredBooks', () {
      test('returns an Iterable of SavedBook after applying the filter', () {
        final state = createSubject(
          status: ShelfStatus.success,
          shelfBooks: [mockSavedBook],
          filter: LibraryFilter.all,
        );
        expect(state.filteredBooks, isA<Iterable<SavedBook>>());
        expect(state.filteredBooks.length, equals(1));
        expect(state.filteredBooks.first, equals(mockSavedBook));
      });
    });
  });
}