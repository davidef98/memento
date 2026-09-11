import 'package:books_api/books_api.dart';
import 'package:dio/dio.dart';

/// {@template open_library_books_api}
/// An implementation of the BooksApi that uses a Dio client
/// for networking and Open Library REST API.
/// {@endtemplate}

const _baseUrl = 'https://openlibrary.org';

/// Fields requested from the Open Library search endpoint to optimize payload size.
const _searchingFields =
    'key,title,author_name,cover_i,first_publish_year,'
    'number_of_pages_median';

class OpenLibraryBooksApi extends BookApi {
  /// If a [dio] client is not provided, a default instance is initialized
  /// using [_baseUrl] as the base options.
  OpenLibraryBooksApi({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: _baseUrl));

  final Dio _dio;

  @override
  Future<BookListResults> searchBooks({
    required String query,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/search.json',
        queryParameters: <String, dynamic>{
          'q': query,
          'fields': _searchingFields,
          'limit': limit,
          'offset': offset,
        },
      );

      final data = response.data;
      if (data == null) {
        throw StateError('Search response body was null.');
      }

      return BookListResults.fromJson(data);
    } on DioException catch (error, stackTrace) {
      throw BookSearchFailure(error, stackTrace);
    } catch (error, stackTrace) {
      throw BookSearchFailure(error, stackTrace);
    }
  }

  @override
  Future<BookDetail> fetchBookDetail(String bookId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '$bookId.json',
      );

      final data = response.data;
      if (data == null) {
        throw StateError('Book detail response body was null.');
      }

      return BookDetail.fromJson(data);
    } on DioException catch (error, stackTrace) {
      if (error.response?.statusCode == 404) {
        throw BookNotFoundFailure(bookId, error, stackTrace);
      }
      throw BookDetailFailure(error, stackTrace);
    } catch (error, stackTrace) {
      throw BookDetailFailure(error, stackTrace);
    }
  }

  @override
  Future<void> close() async {
    _dio.close();
  }
}