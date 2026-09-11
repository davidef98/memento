import 'package:shelf_api/shelf_api.dart';

/// {@template shelf_api}
/// The interface for an API that works with user's shelf.
/// {@endtemplate}

abstract class ShelfApi {
  /// {@macro shelf_api}
  const ShelfApi();

  /// Provides a [Stream] of all saved books.
  Stream<List<SavedBook>> getBooks({ LibrarySortOrder sortOrder = LibrarySortOrder.savedAtDescending,});

  /// Saves a [book].
  ///
  /// If a [SavedBook] with the same id already exists, it will be replaced.
  Future<void> saveBook(SavedBook book);

  /// Deletes the `book` with the given id.
  ///
  /// If no `book` with the given id exists, a [BookNotFoundException] error is
  /// thrown.
  Future<void> deleteBook(String id);

  /// Closes the client and frees up any resources.
  Future<void> close();
}