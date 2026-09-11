import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memento/functionalities/shelf/models/library_filter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_router/go_router.dart';
import 'package:shelf_api/shelf_api.dart';

import 'package:memento/functionalities/shelf/view/shelf_screen.dart';
import 'package:memento/functionalities/shelf/bloc/shelf_bloc/shelf_bloc.dart';
import 'package:memento/functionalities/shelf/widgets/empty_shelf.dart';
import 'package:memento/functionalities/shelf/widgets/error_content.dart';
import 'package:memento/functionalities/shelf/widgets/loading_content.dart';
import 'package:memento/functionalities/shelf/widgets/book_card.dart';
import 'package:memento/widgets/dialogs/wrappers/wrappers.dart';

import '../../../helpers/pump_app.dart';

// --- MOCKS ---
class MockShelfBloc extends MockBloc<ShelfEvent, ShelfState> implements ShelfBloc {}
class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late ShelfBloc shelfBloc;
  late GoRouter goRouter;

  final unreadBook = SavedBook(
    id: '/works/OL1168083W',
    title: 'Nineteen Eighty-Four',
    savedAt: DateTime.utc(2026, 1, 1),
  );

  final completedBook = SavedBook(
    id: '/works/OL1167981W',
    title: 'Animal Farm',
    savedAt: DateTime.utc(2026, 1, 2),
    startDate: DateTime.utc(2026, 1, 3),
    endDate: DateTime.utc(2026, 1, 10),
  );

  setUp(() {
    shelfBloc = MockShelfBloc();
    goRouter = MockGoRouter();

    when(() => goRouter.push(any())).thenAnswer((_) async => null);
  });

  Widget buildSubject() {
    return InheritedGoRouter(
      goRouter: goRouter,
      child: const ShelfScreen(),
    );
  }

  List<BlocProvider> getProviders() => [
    BlocProvider<ShelfBloc>.value(value: shelfBloc),
  ];

  group('ShelfScreen', () {
    testWidgets('renders LoadingContent when status is initial or loading', (tester) async {
      when(() => shelfBloc.state).thenReturn(
        const ShelfState(status: ShelfStatus.loading),
      );

      await tester.pumpApp(buildSubject(), providers: getProviders());

      expect(find.byType(LoadingContent), findsOneWidget);
    });

    testWidgets('renders ErrorContent when status is failure', (tester) async {
      when(() => shelfBloc.state).thenReturn(
        const ShelfState(status: ShelfStatus.failure),
      );

      await tester.pumpApp(buildSubject(), providers: getProviders());

      expect(find.byType(ErrorContent), findsOneWidget);
    });

    testWidgets('renders EmptyContent when shelfBooks is empty', (tester) async {
      when(() => shelfBloc.state).thenReturn(
        const ShelfState(
          status: ShelfStatus.success,
          shelfBooks: [],
        ),
      );

      await tester.pumpApp(buildSubject(), providers: getProviders());

      expect(find.byType(EmptyContent), findsOneWidget);
    });

    group('soft-failure statuses', () {
      // isSuccess deliberately treats these as "successful display"
      // states, so the shelf stays visible while an error bottom
      // sheet fires separately. This is non-obvious behaviour and
      // regresses silently if isSuccess's definition ever changes —
      // worth locking down explicitly, one case per status.
      for (final status in [
        ShelfStatus.addingFailure,
        ShelfStatus.removingFailure,
        ShelfStatus.alreadyInLibraryFailure,
        ShelfStatus.bookNotFoundFailure,
      ]) {
        testWidgets(
          'still renders the book list when status is $status',
              (tester) async {
            when(() => shelfBloc.state).thenReturn(
              ShelfState(status: status, shelfBooks: [unreadBook]),
            );

            await tester.pumpApp(buildSubject(), providers: getProviders());

            expect(find.byType(BookCard), findsOneWidget);
            expect(find.byType(ErrorContent), findsNothing);
            expect(find.byType(EmptyContent), findsNothing);
          },
        );
      }
    });

    group('filtering', () {
      testWidgets(
        'renders emptyFilterResults message when shelfBooks is non-empty '
            'but the active filter matches nothing',
            (tester) async {
          when(() => shelfBloc.state).thenReturn(
            ShelfState(
              status: ShelfStatus.success,
              shelfBooks: [unreadBook],
              filter: LibraryFilter.finished,
            ),
          );

          await tester.pumpApp(buildSubject(), providers: getProviders());

          expect(find.byType(EmptyContent), findsOneWidget);
          expect(find.byType(BookCard), findsNothing);
        },
      );

      testWidgets(
        'renders matching books when the active filter has results',
            (tester) async {
          when(() => shelfBloc.state).thenReturn(
            ShelfState(
              status: ShelfStatus.success,
              shelfBooks: [unreadBook, completedBook],
              filter: LibraryFilter.finished,
            ),
          );

          await tester.pumpApp(buildSubject(), providers: getProviders());

          expect(find.byType(BookCard), findsOneWidget);
        },
      );
    });

    group('error bottom sheet', () {
       testWidgets(
        'shows a GenericErrorDialog when status becomes bookNotFoundFailure',
            (tester) async {
          whenListen(
            shelfBloc,
            Stream.fromIterable([
              const ShelfState(status: ShelfStatus.success),
              const ShelfState(status: ShelfStatus.bookNotFoundFailure),
            ]),
            initialState: const ShelfState(status: ShelfStatus.success),
          );

          await tester.pumpApp(buildSubject(), providers: getProviders());
          await tester.pump();
          await tester.pumpAndSettle();

          expect(find.byType(GenericErrorDialog), findsOneWidget);

          final dialog = tester.widget<GenericErrorDialog>(
            find.byType(GenericErrorDialog),
          );
          expect(dialog.errorMessage, isNotEmpty);
        },
      );

      testWidgets(
        'shows a GenericErrorDialog when status becomes removingFailure',
            (tester) async {
          whenListen(
            shelfBloc,
            Stream.fromIterable([
              const ShelfState(status: ShelfStatus.success),
              const ShelfState(status: ShelfStatus.removingFailure),
            ]),
            initialState: const ShelfState(status: ShelfStatus.success),
          );

          await tester.pumpApp(buildSubject(), providers: getProviders());
          await tester.pump();
          await tester.pumpAndSettle();

          expect(find.byType(GenericErrorDialog), findsOneWidget);
        },
      );

      testWidgets(
        'does not show a GenericErrorDialog for unrelated status changes',
            (tester) async {
          whenListen(
            shelfBloc,
            Stream.fromIterable([
              const ShelfState(status: ShelfStatus.loading),
              const ShelfState(status: ShelfStatus.success),
            ]),
            initialState: const ShelfState(status: ShelfStatus.loading),
          );

          await tester.pumpApp(buildSubject(), providers: getProviders());
          await tester.pumpAndSettle();

          expect(find.byType(GenericErrorDialog), findsNothing);
        },
      );
    });

    group('AppBar Action Buttons', () {
      testWidgets('renders 4 action buttons in CustomSliverAppBar', (tester) async {
        when(() => shelfBloc.state).thenReturn(
          const ShelfState(status: ShelfStatus.success, shelfBooks: []),
        );

        await tester.pumpApp(buildSubject(), providers: getProviders());

        expect(find.byType(IconButton), findsNWidgets(4));
        expect(find.byIcon(Icons.translate), findsOneWidget);
        expect(find.byIcon(CupertinoIcons.arrow_up_arrow_down), findsOneWidget);
        expect(find.byIcon(Icons.sort), findsOneWidget);
      });

      testWidgets('navigates to /search when add button is tapped', (tester) async {
        when(() => shelfBloc.state).thenReturn(
          const ShelfState(status: ShelfStatus.success, shelfBooks: []),
        );

        await tester.pumpApp(buildSubject(), providers: getProviders());

        final addButton = find.byIcon(Icons.add);
        await tester.tap(addButton);
        await tester.pump();

        verify(() => goRouter.push('/search')).called(1);
      });
    });
  });
}