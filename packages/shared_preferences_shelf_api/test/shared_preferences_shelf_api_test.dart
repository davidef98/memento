import 'dart:convert';

import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_shelf_api/shared_preferences_shelf_api.dart';
import 'package:shelf_api/shelf_api.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('SharedPreferencesShelfApi', () {
    late SharedPreferences plugin;

    final books = [
      SavedBook(
        id: '1',
        title: 'Book 1',
        savedAt: DateTime(2023, 1, 1),
      ),
      SavedBook(
        id: '2',
        title: 'Book 2',
        savedAt: DateTime(2023, 1, 2),
      ),
      SavedBook(
        id: '3',
        title: 'Book 3',
        savedAt: DateTime(2023, 1, 3),
        startDate: DateTime(2023, 1, 4),
        endDate: DateTime(2023, 1, 10),
      ),
    ];

    setUp(() {
      plugin = MockSharedPreferences();
      when(() => plugin.getString(any())).thenReturn(json.encode(books));
      when(() => plugin.setString(any(), any())).thenAnswer((_) async => true);
    });

    SharedPreferencesShelfApi createSubject() {
      return SharedPreferencesShelfApi(
        plugin: plugin,
      );
    }

    group('constructor', () {
      test('works properly', () {
        expect(
          createSubject,
          returnsNormally,
        );
      });

      group('initializes the books stream', () {
        test('with existing books if present', () {
          final subject = createSubject();

          expect(subject.getBooks(), emits(books.reversed.toList()));
          verify(
                () => plugin.getString(
              SharedPreferencesShelfApi.kBooksCollectionKey,
            ),
          ).called(1);
        });

        test('with empty list if no books present', () {
          when(() => plugin.getString(any())).thenReturn(null);

          final subject = createSubject();

          expect(subject.getBooks(), emits(const <SavedBook>[]));
          verify(
                () => plugin.getString(
              SharedPreferencesShelfApi.kBooksCollectionKey,
            ),
          ).called(1);
        });
      });
    });

    group('getBooks', () {
      test('returns stream of books in descending order by default', () {
        expect(
          createSubject().getBooks(),
          emits(books.reversed.toList()),
        );
      });

      test('returns stream of books in ascending order when specified', () {
        expect(
          createSubject().getBooks(
            sortOrder: LibrarySortOrder.savedAtAscending,
          ),
          emits(books),
        );
      });
    });

    group('saveBook', () {
      test('saves new books', () {
        final newBook = SavedBook(
          id: '4',
          title: 'Book 4',
          savedAt: DateTime(2023, 1, 5),
        );

        final newBooks = [...books, newBook];

        final subject = createSubject();

        expect(subject.saveBook(newBook), completes);
        expect(
          subject.getBooks(sortOrder: LibrarySortOrder.savedAtAscending),
          emits(newBooks),
        );

        verify(
              () => plugin.setString(
            SharedPreferencesShelfApi.kBooksCollectionKey,
            json.encode(newBooks),
          ),
        ).called(1);
      });

      test('updates existing books', () {
        final updatedBook = SavedBook(
          id: '1',
          title: 'Updated Book 1',
          savedAt: DateTime(2023, 1, 1),
          startDate: DateTime(2023, 1, 2),
        );

        final newBooks = [updatedBook, ...books.sublist(1)];

        final subject = createSubject();

        expect(subject.saveBook(updatedBook), completes);
        expect(
          subject.getBooks(sortOrder: LibrarySortOrder.savedAtAscending),
          emits(newBooks),
        );

        verify(
              () => plugin.setString(
            SharedPreferencesShelfApi.kBooksCollectionKey,
            json.encode(newBooks),
          ),
        ).called(1);
      });
    });

    group('deleteBook', () {
      test('deletes existing books', () {
        final newBooks = books.sublist(1);

        final subject = createSubject();

        expect(subject.deleteBook(books[0].id), completes);
        expect(
          subject.getBooks(sortOrder: LibrarySortOrder.savedAtAscending),
          emits(newBooks),
        );

        verify(
              () => plugin.setString(
            SharedPreferencesShelfApi.kBooksCollectionKey,
            json.encode(newBooks),
          ),
        ).called(1);
      });

      test(
        'throws BookNotFoundException if book '
            'with provided id is not found',
            () {
          final subject = createSubject();

          expect(
                () => subject.deleteBook('non-existing-id'),
            throwsA(isA<BookNotFoundException>()),
          );
        },
      );
    });

    group('close', () {
      test('closes the instance', () async {
        final subject = createSubject();

        await subject.close();

        expect(
              () => subject.saveBook(
            SavedBook(
              id: '1',
              title: 'Title 1',
              savedAt: DateTime.now(),
            ),
          ),
          throwsStateError,
        );
      });
    });
  });
}