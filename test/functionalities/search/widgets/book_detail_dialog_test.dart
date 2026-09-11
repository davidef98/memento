import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:books_api/books_api.dart';
import 'package:books_repository/books_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:memento/functionalities/search/widgets/book_detail_dialog.dart';
import 'package:memento/functionalities/shelf/bloc/shelf_bloc/shelf_bloc.dart';
import 'package:memento/l10n/app_localizations.dart';
import 'package:memento/widgets/buttons/custom_elevated_button.dart';
import 'package:memento/widgets/loading_indicators/custom_loading_indicator.dart';

class MockBooksRepository extends Mock implements BooksRepository {}

class MockShelfBloc extends MockBloc<ShelfEvent, ShelfState> implements ShelfBloc {}

void main() {
  group('BookDetailDialog', () {
    late BooksRepository booksRepository;
    late ShelfBloc shelfBloc;

    const mockBookGeneric = BookGeneric(
      key: '/works/OL1168083W',
      title: '1984',
    );

    const mockBookDetail = BookDetail(
      key: '/works/OL1168083W',
      title: '1984',
      description: 'A dystopian masterpiece.',
    );

    setUpAll(() {
      registerFallbackValue(const ShelfSubscriptionRequested());

      registerFallbackValue(const ShelfState());

      registerFallbackValue(const AddBook(mockBookGeneric));
    });

    setUp(() {
      booksRepository = MockBooksRepository();
      shelfBloc = MockShelfBloc();

      when(() => shelfBloc.state).thenReturn(const ShelfState());
    });

    Widget buildSubject({TargetPlatform platform = TargetPlatform.android}) {
      return MaterialApp(
        theme: ThemeData(platform: platform),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MultiRepositoryProvider(
          providers: [
            RepositoryProvider<BooksRepository>.value(value: booksRepository),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<ShelfBloc>.value(value: shelfBloc),
            ],
            child: const Scaffold(
              body: BookDetailDialog(bookGeneric: mockBookGeneric),
            ),
          ),
        ),
      );
    }

    testWidgets('renders CustomLoadingIndicator while fetching book details', (tester) async {
      final completer = Completer<BookDetail>();

      when(() => booksRepository.fetchBookDetail(any()))
          .thenAnswer((_) => completer.future);

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(CustomLoadingIndicator), findsOneWidget);

      completer.complete(mockBookDetail);
      await tester.pumpAndSettle();
    });

    testWidgets('renders book description and Add to Shelf button on success', (tester) async {
      when(() => booksRepository.fetchBookDetail(mockBookGeneric.key))
          .thenAnswer((_) async => mockBookDetail);

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('A dystopian masterpiece.'), findsOneWidget);
      expect(find.byType(CustomElevatedButton), findsOneWidget);
    });

    testWidgets('renders default fallback text when book description is null', (tester) async {
      const bookDetailNoDesc = BookDetail(
        key: '/works/OL1168083W',
        title: '1984',
        description: null,
      );

      when(() => booksRepository.fetchBookDetail(mockBookGeneric.key))
          .thenAnswer((_) async => bookDetailNoDesc);

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.byType(CustomElevatedButton), findsOneWidget);
    });

    testWidgets('dispatches AddBook to ShelfBloc and closes dialog when tap on Add to Shelf button', (tester) async {
      when(() => booksRepository.fetchBookDetail(mockBookGeneric.key))
          .thenAnswer((_) async => mockBookDetail);

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      final addButton = find.byType(CustomElevatedButton);
      expect(addButton, findsOneWidget);

      await tester.tap(addButton);
      await tester.pumpAndSettle();

      verify(() => shelfBloc.add(const AddBook(mockBookGeneric))).called(1);
    });

    testWidgets('renders error view and allows retry on failure (Android icon)', (tester) async {
      when(() => booksRepository.fetchBookDetail(mockBookGeneric.key))
          .thenThrow(Exception('Network error'));

      await tester.pumpWidget(buildSubject(platform: TargetPlatform.android));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.change_circle_outlined), findsOneWidget);

      when(() => booksRepository.fetchBookDetail(mockBookGeneric.key))
          .thenAnswer((_) async => mockBookDetail);

      await tester.tap(find.byIcon(Icons.change_circle_outlined));
      await tester.pumpAndSettle();

      verify(() => booksRepository.fetchBookDetail(mockBookGeneric.key)).called(2);
      expect(find.text('A dystopian masterpiece.'), findsOneWidget);
    });

    testWidgets('renders correct retry icon on iOS platform', (tester) async {
      when(() => booksRepository.fetchBookDetail(mockBookGeneric.key))
          .thenThrow(Exception('Network error'));

      await tester.pumpWidget(buildSubject(platform: TargetPlatform.iOS));
      await tester.pumpAndSettle();

      expect(find.byIcon(CupertinoIcons.arrow_clockwise), findsOneWidget);
    });
  });
}