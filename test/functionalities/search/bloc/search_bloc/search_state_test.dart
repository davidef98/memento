// ignore_for_file: avoid_redundant_argument_values

import 'package:books_api/books_api.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:memento/functionalities/search/bloc/search_bloc/search_bloc.dart';

void main() {
  group('SearchState', () {
    const mockBook = BookGeneric(
      key: '/works/OL1168083W',
      title: '1984',
    );

    SearchState createSubject({
      SearchStatus status = SearchStatus.initial,
      List<BookGeneric> books = const <BookGeneric>[],
      bool hasReachedMax = false,
      String query = '',
    }) {
      return SearchState(
        status: status,
        books: books,
        hasReachedMax: hasReachedMax,
        query: query,
      );
    }

    test('supports value equality', () {
      expect(
        createSubject(),
        equals(createSubject()),
      );
    });

    test('props are correct', () {
      expect(
        createSubject(
          status: SearchStatus.success,
          books: [mockBook],
          hasReachedMax: true,
          query: '1984',
        ).props,
        equals(<Object?>[
          SearchStatus.success,
          [mockBook],
          '1984',
          true,
        ]),
      );
    });

    group('SearchStatusX', () {
      test('returns true when status is initial', () {
        final state = createSubject(status: SearchStatus.initial);
        expect(state.status.isInitial, isTrue);
        expect(state.status.isLoading, isFalse);
        expect(state.status.isEmpty, isFalse);
        expect(state.status.isQueryPopulated, isFalse);
        expect(state.status.isSuccess, isFalse);
        expect(state.status.isFailure, isFalse);
      });

      test('returns true when status is loading', () {
        final state = createSubject(status: SearchStatus.loading);
        expect(state.status.isInitial, isFalse);
        expect(state.status.isLoading, isTrue);
        expect(state.status.isEmpty, isFalse);
        expect(state.status.isQueryPopulated, isFalse);
        expect(state.status.isSuccess, isFalse);
        expect(state.status.isFailure, isFalse);
      });

      test('returns true when status is empty', () {
        final state = createSubject(status: SearchStatus.empty);
        expect(state.status.isInitial, isFalse);
        expect(state.status.isLoading, isFalse);
        expect(state.status.isEmpty, isTrue);
        expect(state.status.isQueryPopulated, isFalse);
        expect(state.status.isSuccess, isFalse);
        expect(state.status.isFailure, isFalse);
      });

      test('returns true when status is queryPopulated', () {
        final state = createSubject(status: SearchStatus.queryPopulated);
        expect(state.status.isInitial, isFalse);
        expect(state.status.isLoading, isFalse);
        expect(state.status.isEmpty, isFalse);
        expect(state.status.isQueryPopulated, isTrue);
        expect(state.status.isSuccess, isFalse);
        expect(state.status.isFailure, isFalse);
      });

      test('returns true when status is success', () {
        final state = createSubject(status: SearchStatus.success);
        expect(state.status.isInitial, isFalse);
        expect(state.status.isLoading, isFalse);
        expect(state.status.isEmpty, isFalse);
        expect(state.status.isQueryPopulated, isFalse);
        expect(state.status.isSuccess, isTrue);
        expect(state.status.isFailure, isFalse);
      });

      test('returns true when status is failure', () {
        final state = createSubject(status: SearchStatus.failure);
        expect(state.status.isInitial, isFalse);
        expect(state.status.isLoading, isFalse);
        expect(state.status.isEmpty, isFalse);
        expect(state.status.isQueryPopulated, isFalse);
        expect(state.status.isSuccess, isFalse);
        expect(state.status.isFailure, isTrue);
      });
    });

    group('copyWith', () {
      test('returns the same object if no arguments are provided', () {
        expect(
          createSubject().copyWith(),
          equals(createSubject()),
        );
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
          createSubject().copyWith(
            status: null,
            books: null,
            hasReachedMax: null,
            query: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            status: SearchStatus.success,
            books: [mockBook],
            hasReachedMax: true,
            query: 'Orwell',
          ),
          equals(
            createSubject(
              status: SearchStatus.success,
              books: [mockBook],
              hasReachedMax: true,
              query: 'Orwell',
            ),
          ),
        );
      });
    });
  });
}