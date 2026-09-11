import 'package:books_api/books_api.dart';
import 'package:books_repository/books_repository.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf_api/shelf_api.dart';

class MockBookApi extends Mock implements BookApi {}

class MockShelfApi extends Mock implements ShelfApi {}

class FakeSavedBook extends Fake implements SavedBook {}

void main() {
  group('BooksRepository', () {
    late BookApi bookApi;
    late ShelfApi shelfApi;

    final bookGeneric = BookGeneric(
      key: '/works/OL1168083W',
      title: 'Nineteen Eighty-Four',
      authorName: const ['George Orwell'],
      coverI: 9267242,
      numberOfPagesMedium: 318,
    );

    final savedBook = SavedBook(
      id: '/works/OL1168083W',
      title: 'Nineteen Eighty-Four',
      authorName: const ['George Orwell'],
      coverI: 9267242,
      numberOfPagesMedium: 318,
      savedAt: DateTime(2023, 1, 1),
    );

    setUpAll(() {
      registerFallbackValue(FakeSavedBook());
      registerFallbackValue(LibrarySortOrder.savedAtDescending);
    });

    setUp(() {
      bookApi = MockBookApi();
      shelfApi = MockShelfApi();
    });

    BooksRepository createSubject() {
      return BooksRepository(
        bookApi: bookApi,
        shelfApi: shelfApi,
      );
    }

    group('constructor', () {
      test('works properly', () {
        expect(
          createSubject,
          returnsNormally,
        );
      });
    });

    group('searchBooks', () {
      test('delegates call to BookApi', () async {
        const query = '1984';
        const limit = 5;
        const offset = 10;
        const expectedResults = BookListResults(
          numFound: 1,
          start: 0,
          numFoundExact: true,
          docs: [],
        );

        when(
              () => bookApi.searchBooks(
            query: any(named: 'query'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenAnswer((_) async => expectedResults);

        final repository = createSubject();
        final actual = await repository.searchBooks(
          query: query,
          limit: limit,
          offset: offset,
        );

        expect(actual, equals(expectedResults));
        verify(
              () => bookApi.searchBooks(
            query: query,
            limit: limit,
            offset: offset,
          ),
        ).called(1);
      });
    });

    group('fetchBookDetail', () {
      test('delegates call to BookApi', () async {
        const bookId = '/works/OL1168083W';
        const expectedDetail = BookDetail(
          key: bookId,
          title: 'Nineteen Eighty-Four',
        );

        when(() => bookApi.fetchBookDetail(any()))
            .thenAnswer((_) async => expectedDetail);

        final repository = createSubject();
        final actual = await repository.fetchBookDetail(bookId);

        expect(actual, equals(expectedDetail));
        verify(() => bookApi.fetchBookDetail(bookId)).called(1);
      });
    });

    group('getSavedBooks', () {
      test('delegates call to ShelfApi with default order', () {
        when(
              () => shelfApi.getBooks(
            sortOrder: any(named: 'sortOrder'),
          ),
        ).thenAnswer((_) => Stream.value([savedBook]));

        final repository = createSubject();

        expect(
          repository.getSavedBooks(),
          emits([savedBook]),
        );

        verify(
              () => shelfApi.getBooks(
            sortOrder: LibrarySortOrder.savedAtDescending,
          ),
        ).called(1);
      });

      test('delegates call to ShelfApi with specified order', () {
        when(
              () => shelfApi.getBooks(
            sortOrder: any(named: 'sortOrder'),
          ),
        ).thenAnswer((_) => Stream.value([savedBook]));

        final repository = createSubject();

        expect(
          repository.getSavedBooks(order: LibrarySortOrder.savedAtAscending),
          emits([savedBook]),
        );

        verify(
              () => shelfApi.getBooks(
            sortOrder: LibrarySortOrder.savedAtAscending,
          ),
        ).called(1);
      });
    });

    group('addBook', () {
      test('saves book when not already in library', () async {
        when(() => shelfApi.getBooks())
            .thenAnswer((_) => Stream.value(const []));
        when(() => shelfApi.saveBook(any())).thenAnswer((_) async {});

        final repository = createSubject();

        await expectLater(repository.addBook(bookGeneric), completes);

        verify(() => shelfApi.getBooks()).called(1);
        verify(
              () => shelfApi.saveBook(
            any(
              that: isA<SavedBook>()
                  .having((b) => b.id, 'id', bookGeneric.key)
                  .having((b) => b.title, 'title', bookGeneric.title)
                  .having((b) => b.authorName, 'authorName', bookGeneric.authorName)
                  .having((b) => b.coverI, 'coverI', bookGeneric.coverI)
                  .having(
                    (b) => b.numberOfPagesMedium,
                'numberOfPagesMedium',
                bookGeneric.numberOfPagesMedium,
              ),
            ),
          ),
        ).called(1);
      });

      test('throws BookAlreadyInLibraryException when book is already in library', () async {
        when(() => shelfApi.getBooks())
            .thenAnswer((_) => Stream.value([savedBook]));

        final repository = createSubject();

        await expectLater(
              () => repository.addBook(bookGeneric),
          throwsA(
            isA<BookAlreadyInLibraryException>().having(
                  (e) => e.bookId,
              'id',
              bookGeneric.key,
            ),
          ),
        );

        verify(() => shelfApi.getBooks()).called(1);
        verifyNever(() => shelfApi.saveBook(any()));
      });
    });

    group('removeBook', () {
      test('delegates call to ShelfApi', () async {
        when(() => shelfApi.deleteBook(any())).thenAnswer((_) async {});

        final repository = createSubject();

        await expectLater(
          repository.removeBook('/works/OL1168083W'),
          completes,
        );

        verify(() => shelfApi.deleteBook('/works/OL1168083W')).called(1);
      });
    });

    group('updateReadingDates', () {
      test('updates reading dates when book is in library', () async {
        final startDate = DateTime(2023, 1, 10);
        final endDate = DateTime(2023, 1, 20);

        when(() => shelfApi.getBooks())
            .thenAnswer((_) => Stream.value([savedBook]));
        when(() => shelfApi.saveBook(any())).thenAnswer((_) async {});

        final repository = createSubject();

        await expectLater(
          repository.updateReadingDates(
            id: savedBook.id,
            startDate: startDate,
            endDate: endDate,
          ),
          completes,
        );

        verify(() => shelfApi.getBooks()).called(1);
        verify(
              () => shelfApi.saveBook(
            savedBook.copyWith(
              startDate: startDate,
              endDate: endDate,
            ),
          ),
        ).called(1);
      });

      test('throws BookNotFoundException when book is not in library', () async {
        when(() => shelfApi.getBooks())
            .thenAnswer((_) => Stream.value(const []));

        final repository = createSubject();

        await expectLater(
              () => repository.updateReadingDates(
            id: 'non-existing-id',
            startDate: DateTime.now(),
          ),
          throwsA(
            isA<BookNotFoundException>().having(
                  (e) => e.bookId,
              'id',
              'non-existing-id',
            ),
          ),
        );

        verify(() => shelfApi.getBooks()).called(1);
        verifyNever(() => shelfApi.saveBook(any()));
      });
    });

    group('close', () {
      test('closes both BookApi and ShelfApi', () async {
        when(() => bookApi.close()).thenAnswer((_) async {});
        when(() => shelfApi.close()).thenAnswer((_) async {});

        final repository = createSubject();

        await repository.close();

        verify(() => bookApi.close()).called(1);
        verify(() => shelfApi.close()).called(1);
      });
    });
  });
}