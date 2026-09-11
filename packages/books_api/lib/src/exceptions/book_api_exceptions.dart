import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// {@template book_api_exception}
/// A base class for all exceptions thrown by a [BookApi] implementation.
/// {@endtemplate}
@immutable
abstract class BookApiException extends Equatable implements Exception {
  /// {@macro book_api_exception}
  const BookApiException(this.error, this.stackTrace);

  /// The error that was caught.
  final Object error;

  /// The stack trace associated with the error.
  final StackTrace stackTrace;

  @override
  List<Object?> get props => [error];
}

/// {@template book_search_failure}
/// Thrown when [BookApi.searchBooks] fails.
/// {@endtemplate}
class BookSearchFailure extends BookApiException {
  /// {@macro book_search_failure}
  const BookSearchFailure(super.error, super.stackTrace);
}

/// {@template book_detail_failure}
/// Thrown when [BookApi.fetchBookDetail] fails.
/// {@endtemplate}
class BookDetailFailure extends BookApiException {
  /// {@macro book_detail_failure}
  const BookDetailFailure(super.error, super.stackTrace);
}

/// {@template book_not_found_failure}
/// Thrown when [BookApi.fetchBookDetail] is called with a [bookId]
/// that does not correspond to any known book.
/// {@endtemplate}
class BookNotFoundFailure extends BookApiException {
  /// {@macro book_not_found_failure}
  const BookNotFoundFailure(this.bookId, super.error, super.stackTrace);

  /// The identifier that could not be found.
  final String bookId;

  @override
  List<Object?> get props => [...super.props, bookId];
}