part of 'book_detail_bloc.dart';

enum BookStatus { initial, loading, success, failure }

/// Extension methods for [BookStatus] to simplify status evaluation
/// and improve code readability in UI and BLoC logic.
extension BookStatusX on BookStatus {
  bool get isInitial => this == BookStatus.initial;
  bool get isLoading => this == BookStatus.loading;
  bool get isSuccess => this == BookStatus.success;
  bool get isFailure => this == BookStatus.failure;
}

final class BookDetailState extends Equatable {
  const BookDetailState({
    this.status = BookStatus.initial,
    this.book = BookDetail.empty,
    this.errorMessage,
  });

  final BookStatus status;
  final BookDetail book;
  final String? errorMessage;

  BookDetailState copyWith({
    BookStatus? status,
    BookDetail? book,
    String? errorMessage,
  }) {
    return BookDetailState(
        status: status ?? this.status,
        book: book ?? this.book,
        errorMessage: errorMessage ?? this.errorMessage
    );
  }

  @override
  String toString() {
    return '''BookState { 
    status: $status, 
    book: $book
    errorMessage: ${errorMessage ?? ''} }''';
  }

  @override
  List<Object> get props => [status, book, errorMessage ?? ''];
}

