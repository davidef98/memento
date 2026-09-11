import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// {@template library_exception}
/// A base class for all exceptions thrown by `Shelf Api`
/// {@endtemplate}
@immutable
abstract class LibraryException extends Equatable implements Exception {
  /// {@macro library_exception}
  const LibraryException();

  @override
  List<Object?> get props => [];
}

/// {@template library_storage_failure}
/// Thrown when reading from or writing to the local library storage
/// fails unexpectedly (e.g. corrupted or unparsable data).
/// {@endtemplate}
class LibraryStorageFailure extends LibraryException {
  /// {@macro library_storage_failure}
  const LibraryStorageFailure(this.error, this.stackTrace);

  /// The error that was caught.
  final Object error;

  /// The stack trace associated with the error.
  final StackTrace stackTrace;

  @override
  List<Object?> get props => [error];
}

/// {@template book_already_in_library_exception}
/// Thrown when trying to add a book that is already present in the
/// user's library.
/// {@endtemplate}
class BookAlreadyInLibraryException extends LibraryException {
  /// {@macro book_already_in_library_exception}
  const BookAlreadyInLibraryException(this.bookId);

  /// The identifier of the book that was already saved.
  final String bookId;

  @override
  List<Object?> get props => [bookId];
}

/// {@template book_not_in_library_exception}
/// Thrown when trying to update or remove a book that is not present
/// in the user's library.
/// {@endtemplate}
class BookNotFoundException extends LibraryException {
  /// {@macro book_not_in_library_exception}
  const BookNotFoundException(this.bookId);

  /// The identifier of the book that could not be found.
  final String bookId;

  @override
  List<Object?> get props => [bookId];
}