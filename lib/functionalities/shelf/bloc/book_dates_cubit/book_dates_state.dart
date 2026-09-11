part of 'book_dates_cubit.dart';

enum BookDatesStatus { initial, loading, success, failure }

/// The state managed by [BookDatesCubit], containing the current [SavedBook],
/// execution [status], and an optional [errorMessage].
class BookDatesState extends Equatable {
  final SavedBook book;
  final BookDatesStatus status;
  final String? errorMessage;

  const BookDatesState({
    required this.book,
    this.status = BookDatesStatus.initial,
    this.errorMessage,
  });

  BookDatesState copyWith({
    SavedBook? book,
    BookDatesStatus? status,
    String? errorMessage,
  }) {
    return BookDatesState(
      book: book ?? this.book,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [book, status, errorMessage];
}

