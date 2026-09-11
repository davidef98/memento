// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';

import 'package:memento/functionalities/search/bloc/search_bloc/search_bloc.dart';

void main() {
  group('SearchEvent', () {
    group('LoadMoreBooks', () {
      test('supports value equality', () {
        expect(
          LoadMoreBooks(),
          equals(LoadMoreBooks()),
        );
      });

      test('props are correct', () {
        expect(
          LoadMoreBooks().props,
          equals(<Object?>[]),
        );
      });
    });

    group('FetchBooks', () {
      test('supports value equality', () {
        expect(
          FetchBooks('Orwell'),
          equals(FetchBooks('Orwell')),
        );
      });

      test('props are correct', () {
        expect(
          FetchBooks('Orwell').props,
          equals(<Object?>[
            'Orwell',
          ]),
        );
      });
    });

    group('ClearSearch', () {
      test('supports value equality', () {
        expect(
          ClearSearch(),
          equals(ClearSearch()),
        );
      });

      test('props are correct', () {
        expect(
          ClearSearch().props,
          equals(<Object?>[]),
        );
      });
    });

    group('PopulateQuery', () {
      test('supports value equality', () {
        expect(
          PopulateQuery('Tolkien'),
          equals(PopulateQuery('Tolkien')),
        );
      });

      test('props are correct', () {
        expect(
          PopulateQuery('Tolkien').props,
          equals(<Object?>[
            'Tolkien',
          ]),
        );
      });
    });
  });
}