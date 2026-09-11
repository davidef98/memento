// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_api/shelf_api.dart';

import 'package:memento/functionalities/shelf/bloc/book_dates_cubit/book_dates_cubit.dart';

void main() {
  group('BookDatesState', () {
    final mockBook = SavedBook(
      id: '/works/OL1168083W',
      title: '1984',
      savedAt: DateTime(2025),
    );

    BookDatesState createSubject({
      SavedBook? book,
      BookDatesStatus status = BookDatesStatus.initial,
      String? errorMessage,
    }) {
      return BookDatesState(
        book: book ?? mockBook,
        status: status,
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
          status: BookDatesStatus.success,
          errorMessage: 'error',
        ).props,
        equals(<Object?>[
          mockBook,
          BookDatesStatus.success,
          'error',
        ]),
      );
    });

    group('copyWith', () {
      test('returns the same object if no arguments are provided', () {
        expect(
          createSubject().copyWith(),
          equals(createSubject()),
        );
      });

      test('retains old values when parameters are null', () {
        expect(
          createSubject(
            status: BookDatesStatus.success,
            errorMessage: 'old error',
          ).copyWith(
            book: null,
            status: null,
            errorMessage: null,
          ),
          equals(
            createSubject(
              status: BookDatesStatus.success,
              errorMessage: 'old error',
            ),
          ),
        );
      });

      test('replaces non-null parameters correctly', () {
        final updatedBook = mockBook.copyWith(
          startDate: DateTime(2025, 1, 1),
        );

        expect(
          createSubject().copyWith(
            book: updatedBook,
            status: BookDatesStatus.success,
            errorMessage: 'new error',
          ),
          equals(
            createSubject(
              book: updatedBook,
              status: BookDatesStatus.success,
              errorMessage: 'new error',
            ),
          ),
        );
      });
    });
  });
}