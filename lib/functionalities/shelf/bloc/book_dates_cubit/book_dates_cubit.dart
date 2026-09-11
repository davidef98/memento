import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:books_repository/books_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:shelf_api/shelf_api.dart';

part 'book_dates_state.dart';

/// A Cubit that manages the state and logic for updating reading dates
/// (start and end) of a [SavedBook].
class BookDatesCubit extends Cubit<BookDatesState> {
  final BooksRepository _booksRepository;

  /// Creates a [BookDatesCubit] initialized with the target [book] and [booksRepository].
  BookDatesCubit({
    required SavedBook book,
    required BooksRepository booksRepository,
  })  : _booksRepository = booksRepository,
        super(BookDatesState(book: book));

  /// Updates the reading start date for the book and triggers a repository save.
  Future<void> updateStartDate(DateTime? startDate) async {
    final updatedBook = state.book.copyWith(startDate: startDate);
    await _saveDates(
      updatedBook: updatedBook,
      startDate: startDate,
      endDate: state.book.endDate,
    );
  }

  /// Updates the reading end date for the book and triggers a repository save.
  Future<void> updateEndDate(DateTime? endDate) async {
    final updatedBook = state.book.copyWith(endDate: endDate);
    await _saveDates(
      updatedBook: updatedBook,
      startDate: state.book.startDate,
      endDate: endDate,
    );
  }

  /// Persists the updated book reading dates via [_booksRepository] and handles state emissions.
  Future<void> _saveDates({
    required SavedBook updatedBook,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    emit(state.copyWith(status: BookDatesStatus.loading));
    try {
      await _booksRepository.updateReadingDates(
        id: state.book.id,
        startDate: startDate,
        endDate: endDate,
      );
      emit(state.copyWith(
        book: updatedBook,
        status: BookDatesStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BookDatesStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}