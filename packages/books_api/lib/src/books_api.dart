import 'package:books_api/books_api.dart';

/// {@template book_api}
/// The interface for an API that works with books.
/// {@endtemplate}
abstract class BookApi {
  /// {@macro book_api}
  const BookApi();

  /// Searches books in the catalog matching [query].
  ///
  /// Results are paginated via [limit] and [offset].
  Future<BookListResults> searchBooks({
    required String query,
    int limit = 10,
    int offset = 0,
  });

  /// Fetches the details of a single book identified by [bookId]
  /// (e.g. `/works/OL1168083W`).
  Future<BookDetail> fetchBookDetail(String bookId);

  /// Closes the client and frees up any resources.
  Future<void> close();
}