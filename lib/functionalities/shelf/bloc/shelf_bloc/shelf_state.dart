part of 'shelf_bloc.dart';

/// Represents the various asynchronous states of the shelf feature.
///
/// [alreadyInLibraryFailure], [addingFailure], [bookNotFoundFailure] and [removingFailure]
/// will only be used to trigger a BlocListener.
enum ShelfStatus {
  initial, loading, success, failure,
  alreadyInLibraryFailure, addingFailure,
  bookNotFoundFailure, removingFailure
}

/// Extension methods for [ShelfStatus] to simplify status evaluation
/// and improve code readability in UI and BLoC logic.
extension ShelfStatusX on ShelfStatus {
  bool get isInitial => this == ShelfStatus.initial;
  bool get isLoading => this == ShelfStatus.loading;
  bool get isFailure => this == ShelfStatus.failure;
  bool get isAlreadyInLibraryFailure => this == ShelfStatus.alreadyInLibraryFailure;
  bool get isBookNotFoundFailure => this == ShelfStatus.bookNotFoundFailure;
  bool get isAddingFailure => this == ShelfStatus.addingFailure;
  bool get isRemovingFailure => this == ShelfStatus.removingFailure;

  /// Returns `true` if the core shelf data is successfully loaded and available,
  /// treating non-critical operation errors ([addingFailure] and [removingFailure])
  /// as successful display states so the list remains visible while error snackbars trigger
  bool get isSuccess =>
      this == ShelfStatus.success ||
          this == ShelfStatus.addingFailure ||
          this == ShelfStatus.alreadyInLibraryFailure ||
          this == ShelfStatus.removingFailure ||
          this == ShelfStatus.bookNotFoundFailure;
}

final class ShelfState extends Equatable {
  const ShelfState({
    this.status = ShelfStatus.initial,
    this.shelfBooks = const [],
    this.orderBy = LibrarySortOrder.savedAtDescending,
    this.filter = LibraryFilter.all,
  });

  final ShelfStatus status;
  final List<SavedBook> shelfBooks;
  final LibrarySortOrder orderBy;
  final LibraryFilter filter;

  Iterable<SavedBook> get filteredBooks => filter.applyAll(shelfBooks);

  ShelfState copyWith({
    ShelfStatus? status,
    List<SavedBook>? shelfBooks,
    LibrarySortOrder? orderBy,
    LibraryFilter? filter,
  }) {
    return ShelfState(
      status: status ?? this.status,
      shelfBooks: shelfBooks ?? this.shelfBooks,
      orderBy: orderBy ?? this.orderBy,
      filter: filter ?? this.filter
    );
  }

  @override
  List<Object?> get props => [
    status,
    shelfBooks,
    orderBy,
    filter
  ];
}