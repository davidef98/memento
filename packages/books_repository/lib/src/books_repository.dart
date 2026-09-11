import 'package:books_api/books_api.dart';
import 'package:shelf_api/shelf_api.dart';

/// {@template library_repository}
/// A repository that gives access to both the remote book catalog
/// (via [BookApi]) and the user's personal library
/// (via [ShelfApi]).
/// {@endtemplate}
class BooksRepository {
  /// {@macro library_repository}
  const BooksRepository({
    required BookApi bookApi,
    required ShelfApi shelfApi,
  })  : _bookApi = bookApi,
        _shelfApi = shelfApi;

  final BookApi _bookApi;
  final ShelfApi _shelfApi;

  /// Searches the remote catalog for books matching [query].
  ///
  /// See [BookApi.searchBooks].
  Future<BookListResults> searchBooks({
    required String query,
    int limit = 10,
    int offset = 0,
  }) {
    return _bookApi.searchBooks(query: query, limit: limit, offset: offset);
  }

  /// Fetches the remote details of the book identified by [bookId].
  ///
  /// See [BookApi.fetchBookDetail].
  Future<BookDetail> fetchBookDetail(String bookId) {
    return _bookApi.fetchBookDetail(bookId);
  }

  /// Returns the books currently saved in the user's library, sorted
  /// according to [order] (defaults to most-recently-saved first).
  Stream<List<SavedBook>> getSavedBooks({
    LibrarySortOrder order = LibrarySortOrder.savedAtDescending,
  }) {
    return _shelfApi.getBooks(sortOrder: order);
  }

  /// Adds [book] to the user's library.
  ///
  /// Throws a [BookAlreadyInLibraryException] if a book with the same
  /// id has already been saved.
  Future<void> addBook(BookGeneric book) async {
    final currentBooks = await _shelfApi.getBooks().first;
    final alreadySaved = currentBooks.any((saved) => saved.id == book.key);

    if (alreadySaved) {
      throw BookAlreadyInLibraryException(book.key);
    }

    final savedBook = SavedBook(
      id: book.key,
      title: book.title,
      authorName: book.authorName,
      coverI: book.coverI,
      numberOfPagesMedium: book.numberOfPagesMedium,
      savedAt: DateTime.now(),
    );

    await _shelfApi.saveBook(savedBook);
  }

  /// Removes the book identified by [id] from the user's library.
  Future<void> removeBook(String id) => _shelfApi.deleteBook(id);

  /// Updates the reading [startDate] and/or [endDate] of the book
  /// identified by [id]. Only the provided (non-null) dates are
  /// updated; omitted ones are left unchanged.
  ///
  /// Throws a [BookNotInLibraryException] if no book with a matching
  /// id is currently saved.
  Future<void> updateReadingDates({
    required String id,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final currentBooks = await _shelfApi.getBooks().first;
    final index = currentBooks.indexWhere((book) => book.id == id);

    if (index == -1) {
      throw BookNotFoundException(id);
    }

    final updated = currentBooks[index].copyWith(
      startDate: startDate,
      endDate: endDate,
    );
    await _shelfApi.saveBook(updated);
  }

  /// Closes the underlying [BookApi] client and frees up any
  /// resources.
  Future<void> close() async {
    await _bookApi.close();
    await _shelfApi.close();
  }
}