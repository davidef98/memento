import 'package:bloc_test/bloc_test.dart';
import 'package:books_api/books_api.dart';
import 'package:books_repository/books_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:memento/functionalities/search/bloc/book_detail_bloc/book_detail_bloc.dart';

class MockBooksRepository extends Mock implements BooksRepository {}

void main() {
  group('BookDetailBloc', () {
    late BooksRepository booksRepository;

    const bookId = '/works/OL1168083W';
    const mockBookDetail = BookDetail(
      key: bookId,
      title: 'Nineteen Eighty-Four',
    );

    setUp(() {
      booksRepository = MockBooksRepository();
    });

    BookDetailBloc buildBloc() {
      return BookDetailBloc(booksRepository: booksRepository);
    }

    group('constructor', () {
      test('works properly', () {
        expect(buildBloc, returnsNormally);
      });

      test('has correct initial state', () {
        expect(
          buildBloc().state,
          equals(const BookDetailState()),
        );
      });
    });

    group('FetchBook', () {
      blocTest<BookDetailBloc, BookDetailState>(
        'emits [loading, success] when fetchBookDetail succeeds',
        setUp: () {
          when(() => booksRepository.fetchBookDetail(any()))
              .thenAnswer((_) async => mockBookDetail);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const FetchBook(bookId)),
        expect: () => const [
          BookDetailState(status: BookStatus.loading),
          BookDetailState(
            status: BookStatus.success,
            book: mockBookDetail,
          ),
        ],
        verify: (_) {
          verify(() => booksRepository.fetchBookDetail(bookId)).called(1);
        },
      );

      blocTest<BookDetailBloc, BookDetailState>(
        'emits [loading, failure] when fetchBookDetail throws exception',
        setUp: () {
          when(() => booksRepository.fetchBookDetail(any()))
              .thenThrow(Exception('oops'));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const FetchBook(bookId)),
        expect: () => const [
          BookDetailState(status: BookStatus.loading),
          BookDetailState(status: BookStatus.failure),
        ],
        verify: (_) {
          verify(() => booksRepository.fetchBookDetail(bookId)).called(1);
        },
      );
    });
  });
}