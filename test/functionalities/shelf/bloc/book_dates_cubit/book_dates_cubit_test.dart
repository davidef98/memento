import 'package:bloc_test/bloc_test.dart';
import 'package:books_repository/books_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf_api/shelf_api.dart';

import 'package:memento/functionalities/shelf/bloc/book_dates_cubit/book_dates_cubit.dart';

class MockBooksRepository extends Mock implements BooksRepository {}

void main() {
  group('BookDatesCubit', () {
    late BooksRepository booksRepository;

    final mockBook = SavedBook(
      id: '/works/OL1168083W',
      title: '1984',
      savedAt: DateTime(2025),
    );

    final startDate = DateTime(2025, 1, 1);
    final endDate = DateTime(2025, 1, 15);

    setUp(() {
      booksRepository = MockBooksRepository();
    });

    BookDatesCubit buildCubit({SavedBook? book}) {
      return BookDatesCubit(
        book: book ?? mockBook,
        booksRepository: booksRepository,
      );
    }

    group('constructor', () {
      test('works properly', () {
        expect(buildCubit, returnsNormally);
      });

      test('has correct initial state', () {
        expect(
          buildCubit().state,
          equals(BookDatesState(book: mockBook)),
        );
      });
    });

    group('updateStartDate', () {
      blocTest<BookDatesCubit, BookDatesState>(
        'emits [loading, success] with updated book when updateReadingDates succeeds',
        setUp: () {
          when(
                () => booksRepository.updateReadingDates(
              id: any(named: 'id'),
              startDate: any(named: 'startDate'),
              endDate: any(named: 'endDate'),
            ),
          ).thenAnswer((_) async {});
        },
        build: buildCubit,
        act: (cubit) => cubit.updateStartDate(startDate),
        expect: () => [
          BookDatesState(
            book: mockBook,
            status: BookDatesStatus.loading,
          ),
          BookDatesState(
            book: mockBook.copyWith(startDate: startDate),
            status: BookDatesStatus.success,
          ),
        ],
        verify: (_) {
          verify(
                () => booksRepository.updateReadingDates(
              id: mockBook.id,
              startDate: startDate,
              endDate: null,
            ),
          ).called(1);
        },
      );

      blocTest<BookDatesCubit, BookDatesState>(
        'emits [loading, failure] with errorMessage when updateReadingDates throws',
        setUp: () {
          when(
                () => booksRepository.updateReadingDates(
              id: any(named: 'id'),
              startDate: any(named: 'startDate'),
              endDate: any(named: 'endDate'),
            ),
          ).thenThrow(Exception('Update failed'));
        },
        build: buildCubit,
        act: (cubit) => cubit.updateStartDate(startDate),
        expect: () => [
          BookDatesState(
            book: mockBook,
            status: BookDatesStatus.loading,
          ),
          BookDatesState(
            book: mockBook,
            status: BookDatesStatus.failure,
            errorMessage: 'Exception: Update failed',
          ),
        ],
      );
    });

    group('updateEndDate', () {
      blocTest<BookDatesCubit, BookDatesState>(
        'emits [loading, success] with updated book when updateReadingDates succeeds',
        setUp: () {
          when(
                () => booksRepository.updateReadingDates(
              id: any(named: 'id'),
              startDate: any(named: 'startDate'),
              endDate: any(named: 'endDate'),
            ),
          ).thenAnswer((_) async {});
        },
        build: buildCubit,
        act: (cubit) => cubit.updateEndDate(endDate),
        expect: () => [
          BookDatesState(
            book: mockBook,
            status: BookDatesStatus.loading,
          ),
          BookDatesState(
            book: mockBook.copyWith(endDate: endDate),
            status: BookDatesStatus.success,
          ),
        ],
        verify: (_) {
          verify(
                () => booksRepository.updateReadingDates(
              id: mockBook.id,
              startDate: null,
              endDate: endDate,
            ),
          ).called(1);
        },
      );

      blocTest<BookDatesCubit, BookDatesState>(
        'emits [loading, failure] with errorMessage when updateReadingDates throws',
        setUp: () {
          when(
                () => booksRepository.updateReadingDates(
              id: any(named: 'id'),
              startDate: any(named: 'startDate'),
              endDate: any(named: 'endDate'),
            ),
          ).thenThrow(Exception('Update failed'));
        },
        build: buildCubit,
        act: (cubit) => cubit.updateEndDate(endDate),
        expect: () => [
          BookDatesState(
            book: mockBook,
            status: BookDatesStatus.loading,
          ),
          BookDatesState(
            book: mockBook,
            status: BookDatesStatus.failure,
            errorMessage: 'Exception: Update failed',
          ),
        ],
      );
    });
  });
}