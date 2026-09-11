import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:books_api/books_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:memento/functionalities/search/bloc/search_bloc/search_bloc.dart';
import 'package:memento/functionalities/search/view/search_screen.dart';
import 'package:memento/functionalities/search/widgets/book_search_bar.dart';
import 'package:memento/functionalities/search/widgets/search_result_book_card.dart';
import 'package:memento/functionalities/shelf/bloc/shelf_bloc/shelf_bloc.dart';
import 'package:memento/functionalities/shelf/widgets/empty_shelf.dart';
import 'package:memento/functionalities/shelf/widgets/error_content.dart';
import 'package:memento/functionalities/shelf/widgets/loading_content.dart';
import 'package:memento/widgets/loading_indicators/bottom_list_loader.dart';

import '../../../helpers/pump_app.dart';

class MockSearchBloc extends MockBloc<SearchEvent, SearchState>
    implements SearchBloc {}

class MockShelfBloc extends MockBloc<ShelfEvent, ShelfState>
    implements ShelfBloc {}

class MockBookGeneric extends Mock implements BookGeneric {}

void main() {
  late SearchBloc searchBloc;
  late ShelfBloc shelfBloc;
  late BookGeneric dummyBook;

  setUpAll(() {
    registerFallbackValue(const FetchBooks(''));
    registerFallbackValue(LoadMoreBooks());
    registerFallbackValue(ClearSearch());
    registerFallbackValue(const PopulateQuery(''));
  });

  setUp(() {
    searchBloc = MockSearchBloc();
    shelfBloc = MockShelfBloc();
    dummyBook = MockBookGeneric();

    when(() => dummyBook.key).thenReturn('1');
    when(() => dummyBook.title).thenReturn('Clean Code');
    when(() => dummyBook.authorName).thenReturn(
      ['Robert C. Martin'],
    );

    when(() => shelfBloc.state).thenReturn(const ShelfState());
  });

  List<BlocProvider> getProviders() {
    return [
      BlocProvider<SearchBloc>.value(value: searchBloc),
      BlocProvider<ShelfBloc>.value(value: shelfBloc),
    ];
  }

  Future<void> pumpSearchScreen(
      WidgetTester tester, {
        SearchState? searchState,
        ShelfState? shelfState,
      }) async {
    when(() => searchBloc.state).thenReturn(
      searchState ?? const SearchState(),
    );

    when(() => shelfBloc.state).thenReturn(
      shelfState ?? const ShelfState(),
    );

    await tester.pumpApp(
      const SearchScreenContent(),
      providers: getProviders(),
    );

    await tester.pump();
  }

  group('SearchScreenContent', () {
    group('initial state', () {
      testWidgets(
        'renders EmptyContent',
            (tester) async {
          await pumpSearchScreen(
            tester,
            searchState: const SearchState(
              status: SearchStatus.initial,
            ),
          );

          expect(find.byType(EmptyContent), findsOneWidget);
          expect(find.byType(BookSearchBar), findsOneWidget);
          expect(find.byType(LoadingContent), findsNothing);
          expect(find.byType(ErrorContent), findsNothing);
          expect(find.byType(SearchResultBookCard), findsNothing);
        },
      );
    });

    group('loading state', () {
      testWidgets(
        'renders LoadingContent',
            (tester) async {
          await pumpSearchScreen(
            tester,
            searchState: const SearchState(
              status: SearchStatus.loading,
            ),
          );

          expect(find.byType(LoadingContent), findsOneWidget);
          expect(find.byType(EmptyContent), findsNothing);
          expect(find.byType(ErrorContent), findsNothing);
          expect(find.byType(SearchResultBookCard), findsNothing);
        },
      );
    });

    group('failure state', () {
      testWidgets(
        'renders ErrorContent',
            (tester) async {
          await pumpSearchScreen(
            tester,
            searchState: const SearchState(
              status: SearchStatus.failure,
              query: 'Flutter',
            ),
          );

          expect(find.byType(ErrorContent), findsOneWidget);
          expect(find.byType(LoadingContent), findsNothing);
          expect(find.byType(SearchResultBookCard), findsNothing);
        },
      );

      testWidgets(
        'shows error content and retries search when pressed',
            (tester) async {
          final searchBloc = MockSearchBloc();
          final shelfBloc = MockShelfBloc();

          when(() => searchBloc.state).thenReturn(
            const SearchState(
              status: SearchStatus.failure,
              query: 'Flutter',
            ),
          );

          when(() => shelfBloc.state).thenReturn(const ShelfState());

          await tester.pumpApp(
            BlocProvider<SearchBloc>.value(
              value: searchBloc,
              child: BlocProvider<ShelfBloc>.value(
                value: shelfBloc,
                child: const SearchScreenContent(),
              ),
            ),
          );

          await tester.pump();

          final errorContent = find.byType(ErrorContent);

          expect(errorContent, findsOneWidget);

          final retryButton = find.descendant(
            of: errorContent,
            matching: find.byType(IconButton),
          );

          expect(retryButton, findsOneWidget);

          await tester.tap(retryButton);
          await tester.pump();

          verify(
                () => searchBloc.add(const FetchBooks('Flutter')),
          ).called(1);
        },
      );
    });

    group('empty results', () {
      testWidgets(
        'renders EmptyContent when search succeeds with no books',
            (tester) async {
          await pumpSearchScreen(
            tester,
            searchState: const SearchState(
              status: SearchStatus.success,
              books: [],
              hasReachedMax: true,
            ),
          );

          expect(find.byType(EmptyContent), findsOneWidget);
          expect(find.byType(SearchResultBookCard), findsNothing);
          expect(find.byType(BottomListLoader), findsNothing);
        },
      );
    });

    group('successful search', () {
      testWidgets(
        'renders one SearchResultBookCard for each book',
            (tester) async {
          final books = List<BookGeneric>.generate(
            3,
                (_) => dummyBook,
          );

          await pumpSearchScreen(
            tester,
            searchState: SearchState(
              status: SearchStatus.success,
              books: books,
              hasReachedMax: true,
            ),
          );

          expect(
            find.byType(SearchResultBookCard),
            findsNWidgets(3),
          );
        },
      );

      testWidgets(
        'does not render BottomListLoader when hasReachedMax is true',
            (tester) async {
          await pumpSearchScreen(
            tester,
            searchState: SearchState(
              status: SearchStatus.success,
              books: [dummyBook],
              hasReachedMax: true,
            ),
          );

          expect(find.byType(SearchResultBookCard), findsOneWidget);
          expect(find.byType(BottomListLoader), findsNothing);
        },
      );

      testWidgets(
        'renders BottomListLoader when hasReachedMax is false',
            (tester) async {
          await pumpSearchScreen(
            tester,
            searchState: SearchState(
              status: SearchStatus.success,
              books: [dummyBook],
              hasReachedMax: false,
            ),
          );

          expect(find.byType(SearchResultBookCard), findsOneWidget);
          expect(find.byType(BottomListLoader), findsOneWidget);
        },
      );
    });

    group('query population', () {
      testWidgets(
        'populates search field when SearchStatus is queryPopulated',
            (tester) async {
          const query = 'Design Patterns';

          whenListen(
            searchBloc,
            Stream<SearchState>.fromIterable([
              const SearchState(
                status: SearchStatus.queryPopulated,
                query: query,
              ),
            ]),
            initialState: const SearchState(
              status: SearchStatus.initial,
            ),
          );

          await tester.pumpApp(
            const SearchScreenContent(),
            providers: getProviders(),
          );

          // Rebuild after the SearchBloc emits queryPopulated.
          await tester.pump();

          // _populateQuery uses addPostFrameCallback.
          await tester.pump();

          final textField = find.byType(SearchBar);

          expect(textField, findsOneWidget);
          expect(find.text(query), findsOneWidget);
        },
      );
    });

    group('search bar', () {
      testWidgets(
        'dispatches FetchBooks when a valid query is submitted',
            (tester) async {
          when(() => searchBloc.state).thenReturn(
            const SearchState(
              status: SearchStatus.initial,
            ),
          );

          await tester.pumpApp(
            const SearchScreenContent(),
            providers: getProviders(),
          );

          final searchBar = find.byType(SearchBar);
          expect(searchBar, findsOneWidget);

          await tester.tap(searchBar);
          await tester.enterText(
            searchBar,
            'Flutter',
          );

          await tester.testTextInput.receiveAction(
            TextInputAction.search,
          );

          await tester.pump();

          verify(
                () => searchBloc.add(
              const FetchBooks('Flutter'),
            ),
          ).called(1);
        },
      );
    });

    group('pagination', () {
      testWidgets(
        'dispatches LoadMoreBooks when scrolling to the bottom',
            (tester) async {
          final books = List<BookGeneric>.generate(
            20,
                (_) => dummyBook,
          );

          await pumpSearchScreen(
            tester,
            searchState: SearchState(
              status: SearchStatus.success,
              books: books,
              hasReachedMax: false,
            ),
          );

          final scrollView = find.byType(CustomScrollView);
          expect(scrollView, findsOneWidget);

          await tester.drag(
            scrollView,
            const Offset(0, -5000),
          );

          await tester.pump();

          verify(
                () => searchBloc.add(
              LoadMoreBooks(),
            ),
          ).called(1);
        },
      );
    });
  });
}