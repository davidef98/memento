part of 'book_detail_bloc.dart';

/// Base class for all events handled by the [BookDetailBloc].
sealed class BookDetailEvent extends Equatable {
  const BookDetailEvent();

  @override
  List<Object> get props => [];
}

/// Event dispatched to fetch details for a specific book by its unique identifier.
final class FetchBook extends BookDetailEvent {
  final String bookId;

  const FetchBook(this.bookId);

  @override
  List<Object> get props => [bookId];
}



