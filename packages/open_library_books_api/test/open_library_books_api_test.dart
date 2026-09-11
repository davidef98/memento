import 'package:books_api/books_api.dart';
import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:open_library_books_api/open_library_books_api.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('OpenLibraryBooksApi', () {
    late Dio dio;

    const query = '1984';
    const bookId = '/works/OL1168083W';

    final searchResponseBody = <String, dynamic>{
      'numFound': 1,
      'start': 0,
      'numFoundExact': true,
      'docs': [
        <String, dynamic>{
          'key': bookId,
          'title': 'Nineteen Eighty-Four',
          'author_name': ['George Orwell'],
          'cover_i': 9267242,
          'first_publish_year': 1949,
          'number_of_pages_median': 318,
        },
      ],
    };

    final detailResponseBody = <String, dynamic>{
      'key': bookId,
      'title': 'Nineteen Eighty-Four',
      'description': 'A dystopian novel.',
      'subjects': ['Dystopia'],
      'covers': [9267242],
      'first_publish_date': '1949',
    };

    setUp(() {
      dio = MockDio();
    });

    OpenLibraryBooksApi createSubject() {
      return OpenLibraryBooksApi(dio: dio);
    }

    group('constructor', () {
      test('does not require a dio client instance', () {
        expect(OpenLibraryBooksApi.new, returnsNormally);
      });
    });

    group('searchBooks', () {
      test('returns BookListResults when request succeeds', () async {
        final response = Response<Map<String, dynamic>>(
          data: searchResponseBody,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/search.json'),
        );

        when(
              () => dio.get<Map<String, dynamic>>(
            '/search.json',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => response);

        final api = createSubject();
        final actual = await api.searchBooks(query: query);

        expect(actual, isA<BookListResults>());
        expect(actual.numFound, equals(1));
        expect(actual.docs.first.title, equals('Nineteen Eighty-Four'));

        verify(
              () => dio.get<Map<String, dynamic>>(
            '/search.json',
            queryParameters: <String, dynamic>{
              'q': query,
              'fields':
              'key,title,author_name,cover_i,first_publish_year,'
                  'number_of_pages_median',
              'limit': 10,
              'offset': 0,
            },
          ),
        ).called(1);
      });

      test('throws BookSearchFailure when response data is null', () async {
        final response = Response<Map<String, dynamic>>(
          data: null,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/search.json'),
        );

        when(
              () => dio.get<Map<String, dynamic>>(
            '/search.json',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => response);

        final api = createSubject();

        await expectLater(
              () => api.searchBooks(query: query),
          throwsA(isA<BookSearchFailure>()),
        );
      });

      test('throws BookSearchFailure on DioException', () async {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/search.json'),
          type: DioExceptionType.connectionTimeout,
        );

        when(
              () => dio.get<Map<String, dynamic>>(
            '/search.json',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(dioException);

        final api = createSubject();

        await expectLater(
              () => api.searchBooks(query: query),
          throwsA(isA<BookSearchFailure>()),
        );
      });

      test('throws BookSearchFailure on generic Exception', () async {
        when(
              () => dio.get<Map<String, dynamic>>(
            '/search.json',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(Exception('Unknown error'));

        final api = createSubject();

        await expectLater(
              () => api.searchBooks(query: query),
          throwsA(isA<BookSearchFailure>()),
        );
      });
    });

    group('fetchBookDetail', () {
      test('returns BookDetail when request succeeds', () async {
        final response = Response<Map<String, dynamic>>(
          data: detailResponseBody,
          statusCode: 200,
          requestOptions: RequestOptions(path: '$bookId.json'),
        );

        when(
              () => dio.get<Map<String, dynamic>>('$bookId.json'),
        ).thenAnswer((_) async => response);

        final api = createSubject();
        final actual = await api.fetchBookDetail(bookId);

        expect(actual, isA<BookDetail>());
        expect(actual.key, equals(bookId));
        expect(actual.title, equals('Nineteen Eighty-Four'));

        verify(() => dio.get<Map<String, dynamic>>('$bookId.json')).called(1);
      });

      test('throws BookDetailFailure when response data is null', () async {
        final response = Response<Map<String, dynamic>>(
          data: null,
          statusCode: 200,
          requestOptions: RequestOptions(path: '$bookId.json'),
        );

        when(
              () => dio.get<Map<String, dynamic>>('$bookId.json'),
        ).thenAnswer((_) async => response);

        final api = createSubject();

        await expectLater(
              () => api.fetchBookDetail(bookId),
          throwsA(isA<BookDetailFailure>()),
        );
      });

      test('throws BookNotFoundFailure on DioException with 404 status code',
              () async {
            final dioException = DioException(
              requestOptions: RequestOptions(path: '$bookId.json'),
              response: Response<dynamic>(
                statusCode: 404,
                requestOptions: RequestOptions(path: '$bookId.json'),
              ),
            );

            when(
                  () => dio.get<Map<String, dynamic>>('$bookId.json'),
            ).thenThrow(dioException);

            final api = createSubject();

            await expectLater(
                  () => api.fetchBookDetail(bookId),
              throwsA(
                isA<BookNotFoundFailure>().having(
                      (f) => f.bookId,
                  'id',
                  bookId,
                ),
              ),
            );
          });

      test('throws BookDetailFailure on DioException with non-404 status code',
              () async {
            final dioException = DioException(
              requestOptions: RequestOptions(path: '$bookId.json'),
              response: Response<dynamic>(
                statusCode: 500,
                requestOptions: RequestOptions(path: '$bookId.json'),
              ),
            );

            when(
                  () => dio.get<Map<String, dynamic>>('$bookId.json'),
            ).thenThrow(dioException);

            final api = createSubject();

            await expectLater(
                  () => api.fetchBookDetail(bookId),
              throwsA(isA<BookDetailFailure>()),
            );
          });

      test('throws BookDetailFailure on generic Exception', () async {
        when(
              () => dio.get<Map<String, dynamic>>('$bookId.json'),
        ).thenThrow(Exception('Generic error'));

        final api = createSubject();

        await expectLater(
              () => api.fetchBookDetail(bookId),
          throwsA(isA<BookDetailFailure>()),
        );
      });
    });

    group('close', () {
      test('closes internal dio instance', () async {
        final api = createSubject();

        await api.close();

        verify(() => dio.close()).called(1);
      });
    });
  });
}