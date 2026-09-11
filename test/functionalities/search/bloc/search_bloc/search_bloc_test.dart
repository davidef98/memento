import 'package:bloc_test/bloc_test.dart';
import 'package:books_api/books_api.dart';
import 'package:books_repository/books_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:memento/functionalities/search/bloc/search_bloc/search_bloc.dart';

class MockBooksRepository extends Mock implements BooksRepository {}

void main() {
  group('SearchBloc', () {
    late BooksRepository booksRepository;

    const mockBook = BookGeneric(
      key: '/works/OL1168083W',
      title: '1984',
    );

    const mockBookListResults = BookListResults(
      numFound: 10,
      start: 0,
      numFoundExact: true,
      docs: [mockBook],
    );

    const mockEmptyBookListResults = BookListResults(
      numFound: 0,
      start: 0,
      numFoundExact: true,
      docs: [],
    );

    setUp(() {
      booksRepository = MockBooksRepository();
    });

    SearchBloc buildBloc() {
      return SearchBloc(booksRepository: booksRepository);
    }

    group('constructor', () {
      test('works properly', () {
        expect(buildBloc, returnsNormally);
      });

      test('has correct initial state', () {
        expect(
          buildBloc().state,
          equals(const SearchState()),
        );
      });
    });

    group('FetchBooks', () {
      blocTest<SearchBloc, SearchState>(
        'emits [loading, success] when search returns results',
        setUp: () {
          when(
                () => booksRepository.searchBooks(
              query: any(named: 'query'),
            ),
          ).thenAnswer((_) async => mockBookListResults);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(FetchBooks('George Orwell')),
        expect: () => const [
          SearchState(status: SearchStatus.loading),
          SearchState(
            status: SearchStatus.success,
            books: [mockBook],
            query: 'George Orwell',
            hasReachedMax: false,
          ),
        ],
        verify: (_) {
          verify(
                () => booksRepository.searchBooks(query: 'George Orwell'),
          ).called(1);
        },
      );

      blocTest<SearchBloc, SearchState>(
        'emits [loading, success] with hasReachedMax true when fetched count equals or exceeds numFound',
        setUp: () {
          when(
                () => booksRepository.searchBooks(
              query: any(named: 'query'),
            ),
          ).thenAnswer(
                (_) async => const BookListResults(
              numFound: 1,
              start: 0,
              numFoundExact: true,
              docs: [mockBook],
            ),
          );
        },
        build: buildBloc,
        act: (bloc) => bloc.add(FetchBooks('George Orwell')),
        expect: () => const [
          SearchState(status: SearchStatus.loading),
          SearchState(
            status: SearchStatus.success,
            books: [mockBook],
            query: 'George Orwell',
            hasReachedMax: true,
          ),
        ],
      );

      blocTest<SearchBloc, SearchState>(
        'emits [loading, empty] when search returns no results',
        setUp: () {
          when(
                () => booksRepository.searchBooks(
              query: any(named: 'query'),
            ),
          ).thenAnswer((_) async => mockEmptyBookListResults);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(FetchBooks('NonExistentBook123')),
        expect: () => const [
          SearchState(status: SearchStatus.loading),
          SearchState(
            status: SearchStatus.empty,
            books: [],
            query: 'NonExistentBook123',
            hasReachedMax: false,
          ),
        ],
      );

      blocTest<SearchBloc, SearchState>(
        'emits [loading, failure] when search throws an exception',
        setUp: () {
          when(
                () => booksRepository.searchBooks(
              query: any(named: 'query'),
            ),
          ).thenThrow(Exception('Network Error'));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(FetchBooks('George Orwell')),
        expect: () => const [
          SearchState(status: SearchStatus.loading),
          SearchState(status: SearchStatus.failure),
        ],
      );
    });

    group('LoadMoreBooks', () {
      const secondBook = BookGeneric(
        key: '/works/OL1168084W',
        title: 'Animal Farm',
      );

      blocTest<SearchBloc, SearchState>(
        'does nothing when state.hasReachedMax is true',
        seed: () => const SearchState(
          status: SearchStatus.success,
          books: [mockBook],
          query: 'George Orwell',
          hasReachedMax: true,
        ),
        build: buildBloc,
        act: (bloc) => bloc.add(LoadMoreBooks()),
        expect: () => <SearchState>[],
        verify: (_) {
          verifyNever(
                () => booksRepository.searchBooks(
              query: any(named: 'query'),
              offset: any(named: 'offset'),
            ),
          );
        },
      );

      blocTest<SearchBloc, SearchState>(
        'emits updated state with appended books when additional results are returned',
        seed: () => const SearchState(
          status: SearchStatus.success,
          books: [mockBook],
          query: 'George Orwell',
          hasReachedMax: false,
        ),
        setUp: () {
          when(
                () => booksRepository.searchBooks(
              query: any(named: 'query'),
              offset: any(named: 'offset'),
            ),
          ).thenAnswer(
                (_) async => const BookListResults(
              numFound: 10,
              start: 1,
              numFoundExact: true,
              docs: [secondBook],
            ),
          );
        },
        build: buildBloc,
        act: (bloc) => bloc.add(LoadMoreBooks()),
        expect: () => const [
          SearchState(
            status: SearchStatus.success,
            books: [mockBook, secondBook],
            query: 'George Orwell',
            hasReachedMax: false,
          ),
        ],
        verify: (_) {
          verify(
                () => booksRepository.searchBooks(
              query: 'George Orwell',
              offset: 1,
            ),
          ).called(1);
        },
      );

      blocTest<SearchBloc, SearchState>(
        'emits state with hasReachedMax true when new results docs are empty',
        seed: () => const SearchState(
          status: SearchStatus.success,
          books: [mockBook],
          query: 'George Orwell',
          hasReachedMax: false,
        ),
        setUp: () {
          when(
                () => booksRepository.searchBooks(
              query: any(named: 'query'),
              offset: any(named: 'offset'),
            ),
          ).thenAnswer((_) async => mockEmptyBookListResults);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(LoadMoreBooks()),
        expect: () => const [
          SearchState(
            status: SearchStatus.success,
            books: [mockBook],
            query: 'George Orwell',
            hasReachedMax: true,
          ),
        ],
      );

      blocTest<SearchBloc, SearchState>(
        'emits failure status when loadMore throws an exception',
        seed: () => const SearchState(
          status: SearchStatus.success,
          books: [mockBook],
          query: 'George Orwell',
          hasReachedMax: false,
        ),
        setUp: () {
          when(
                () => booksRepository.searchBooks(
              query: any(named: 'query'),
              offset: any(named: 'offset'),
            ),
          ).thenThrow(Exception('Fetch error'));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(LoadMoreBooks()),
        expect: () => const [
          SearchState(
            status: SearchStatus.failure,
            books: [mockBook],
            query: 'George Orwell',
            hasReachedMax: false,
          ),
        ],
      );
    });

    group('PopulateQuery', () {
      blocTest<SearchBloc, SearchState>(
        'emits queryPopulated status with updated query and empty books list',
        seed: () => const SearchState(
          status: SearchStatus.success,
          books: [mockBook],
        ),
        build: buildBloc,
        act: (bloc) => bloc.add(PopulateQuery('Dune')),
        expect: () => const [
          SearchState(
            status: SearchStatus.queryPopulated,
            books: [],
            hasReachedMax: false,
            query: 'Dune',
          ),
        ],
      );
    });

    group('ClearSearch', () {
      blocTest<SearchBloc, SearchState>(
        'resets search state to initial state values',
        seed: () => const SearchState(
          status: SearchStatus.success,
          books: [mockBook],
          hasReachedMax: true,
          query: 'George Orwell',
        ),
        build: buildBloc,
        act: (bloc) => bloc.add(ClearSearch()),
        expect: () => const [
          SearchState(
            status: SearchStatus.initial,
            books: [],
            hasReachedMax: false,
            query: '',
          ),
        ],
      );
    });
  });
}