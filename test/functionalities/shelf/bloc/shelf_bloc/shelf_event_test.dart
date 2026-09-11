// ignore_for_file: prefer_const_constructors

import 'package:books_api/books_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_api/shelf_api.dart';

import 'package:memento/functionalities/shelf/bloc/shelf_bloc/shelf_bloc.dart';
import 'package:memento/functionalities/shelf/models/library_filter.dart';

void main() {
  group('ShelfEvent', () {
    const mockBook = BookGeneric(
      key: '/works/OL1168083W',
      title: '1984',
    );

    group('ShelfSubscriptionRequested', () {
      test('supports value equality', () {
        expect(
          ShelfSubscriptionRequested(),
          equals(ShelfSubscriptionRequested()),
        );
      });

      test('props are correct', () {
        expect(
          ShelfSubscriptionRequested().props,
          equals(<Object?>[]),
        );
      });
    });

    group('AddBook', () {
      test('supports value equality', () {
        expect(
          AddBook(mockBook),
          equals(AddBook(mockBook)),
        );
      });

      test('props are correct', () {
        expect(
          AddBook(mockBook).props,
          equals(<Object?>[
            mockBook,
          ]),
        );
      });
    });

    group('DeleteSavedBook', () {
      test('supports value equality', () {
        expect(
          DeleteSavedBook('saved-1'),
          equals(DeleteSavedBook('saved-1')),
        );
      });

      test('props are correct', () {
        expect(
          DeleteSavedBook('saved-1').props,
          equals(<Object?>[
            'saved-1',
          ]),
        );
      });
    });

    group('SortShelfOrderChanged', () {
      test('supports value equality', () {
        expect(
          SortShelfOrderChanged(LibrarySortOrder.savedAtAscending),
          equals(SortShelfOrderChanged(LibrarySortOrder.savedAtAscending)),
        );
      });

      test('props are correct', () {
        expect(
          SortShelfOrderChanged(LibrarySortOrder.savedAtAscending).props,
          equals(<Object?>[
            LibrarySortOrder.savedAtAscending,
          ]),
        );
      });
    });

    group('ShelfFilterChanged', () {
      test('supports value equality', () {
        expect(
          ShelfFilterChanged(LibraryFilter.all),
          equals(ShelfFilterChanged(LibraryFilter.all)),
        );
      });

      test('props are correct', () {
        expect(
          ShelfFilterChanged(LibraryFilter.all).props,
          equals(<Object?>[
            LibraryFilter.all,
          ]),
        );
      });
    });
  });
}