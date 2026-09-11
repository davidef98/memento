part of 'shelf_bloc.dart';

/// Base class for all events handled by the [ShelfBloc].
sealed class ShelfEvent extends Equatable {
  const ShelfEvent();

  @override
  List<Object> get props => [];
}

/// Event dispatched when the UI requests to subscribe to real-time
/// shelf updates from the repository.
final class ShelfSubscriptionRequested extends ShelfEvent {
  const ShelfSubscriptionRequested();
}

/// Event dispatched to add a new book to the user's shelf.
final class AddBook extends ShelfEvent {
  const AddBook(this.newBook);

  final BookGeneric newBook;

  @override
  List<Object> get props => [newBook];
}

/// Event dispatched to remove a saved book from the shelf by its unique identifier.
final class DeleteSavedBook extends ShelfEvent {
  const DeleteSavedBook(this.savedBookId);

  final String savedBookId;

  @override
  List<Object> get props => [savedBookId];
}

/// Event dispatched to change the sorting order of the shelf items.
final class SortShelfOrderChanged extends ShelfEvent {
  const SortShelfOrderChanged(this.newSortOrder);

  final LibrarySortOrder newSortOrder;

  @override
  List<Object> get props => [newSortOrder];
}

class ShelfFilterChanged extends ShelfEvent {
  const ShelfFilterChanged(this.filter);

  final LibraryFilter filter;

  @override
  List<Object> get props => [filter];
}
