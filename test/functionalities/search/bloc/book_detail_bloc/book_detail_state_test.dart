// ignore_for_file: avoid_redundant_argument_values

import 'package:books_api/books_api.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:memento/functionalities/search/bloc/book_detail_bloc/book_detail_bloc.dart';

void main() {
  group('BookDetailState', () {
    const mockBookDetail = BookDetail(
      key: '/works/OL1168083W',
      title: 'Nineteen Eighty-Four',
    );

    BookDetailState createSubject({
      BookStatus status = BookStatus.initial,
      BookDetail book = BookDetail.empty,
      String? errorMessage,
    }) {
      return BookDetailState(
        status: status,
        book: book,
        errorMessage: errorMessage,
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
          status: BookStatus.initial,
          book: mockBookDetail,
          errorMessage: 'error',
        ).props,
        equals(<Object?>[
          BookStatus.initial,
          mockBookDetail,
          'error',
        ]),
      );
    });

    group('BookStatusX', () {
      test('returns true when status is initial', () {
        final state = createSubject(status: BookStatus.initial);
        expect(state.status.isInitial, isTrue);
        expect(state.status.isLoading, isFalse);
        expect(state.status.isSuccess, isFalse);
        expect(state.status.isFailure, isFalse);
      });

      test('returns true when status is loading', () {
        final state = createSubject(status: BookStatus.loading);
        expect(state.status.isInitial, isFalse);
        expect(state.status.isLoading, isTrue);
        expect(state.status.isSuccess, isFalse);
        expect(state.status.isFailure, isFalse);
      });

      test('returns true when status is success', () {
        final state = createSubject(status: BookStatus.success);
        expect(state.status.isInitial, isFalse);
        expect(state.status.isLoading, isFalse);
        expect(state.status.isSuccess, isTrue);
        expect(state.status.isFailure, isFalse);
      });

      test('returns true when status is failure', () {
        final state = createSubject(status: BookStatus.failure);
        expect(state.status.isInitial, isFalse);
        expect(state.status.isLoading, isFalse);
        expect(state.status.isSuccess, isFalse);
        expect(state.status.isFailure, isTrue);
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
            book: null,
            errorMessage: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            status: BookStatus.success,
            book: mockBookDetail,
            errorMessage: 'error',
          ),
          equals(
            createSubject(
              status: BookStatus.success,
              book: mockBookDetail,
              errorMessage: 'error',
            ),
          ),
        );
      });
    });
  });
}