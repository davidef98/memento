import 'package:bloc_test/bloc_test.dart';
import 'package:books_api/books_api.dart';
import 'package:books_repository/books_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memento/functionalities/search/widgets/book_detail_dialog.dart';
import 'package:memento/functionalities/shelf/bloc/shelf_bloc/shelf_bloc.dart';
import 'package:memento/functionalities/shelf/widgets/book_dates_dialog.dart';
import 'package:memento/functionalities/shelf/widgets/shelf_sort_dialog.dart';
import 'package:memento/l10n/app_localizations.dart';
import 'package:memento/utilities/dialogs/dialog_utilities.dart';
import 'package:memento/widgets/dialogs/wrappers/wrappers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf_api/shelf_api.dart';

class MockShelfBloc extends MockBloc<ShelfEvent, ShelfState> implements ShelfBloc {}

class MockBooksRepository extends Mock implements BooksRepository {}

class MockBookGeneric extends Mock implements BookGeneric {}

class MockSavedBook extends Mock implements SavedBook {}

const _openModalText = 'Open Modal';

void main() {
  late ShelfBloc mockShelfBloc;
  late BooksRepository mockBooksRepository;

  setUp(() {
    mockShelfBloc = MockShelfBloc();
    mockBooksRepository = MockBooksRepository();
    when(() => mockShelfBloc.state).thenReturn(const ShelfState());
  });

  Widget buildTestableWidget({
    required void Function(BuildContext context) onTap,
    ShelfBloc? bloc,
  }) {
    final body = Builder(
      builder: (context) => ElevatedButton(
        onPressed: () => onTap(context),
        child: const Text(_openModalText),
      ),
    );

    return RepositoryProvider<BooksRepository>.value(
      value: mockBooksRepository,
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: bloc != null
              ? BlocProvider<ShelfBloc>.value(value: bloc, child: body)
              : body,
        ),
      ),
    );
  }

  group('DialogUtilities', () {
    testWidgets('showLanguageBottomSheet shows LanguageDialog', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          onTap: (context) => DialogUtilities.showLanguageBottomSheet(context),
        ),
      );

      await tester.tap(find.text(_openModalText));
      await tester.pumpAndSettle();

      expect(find.byType(LanguageDialog), findsOneWidget);
    });

    testWidgets('showErrorBottomSheet shows GenericErrorDialog with the correct message', (tester) async {
      const errorMessage = 'Connection error';

      await tester.pumpWidget(
        buildTestableWidget(
          onTap: (context) => DialogUtilities.showErrorBottomSheet(context, errorMessage),
        ),
      );

      await tester.tap(find.text(_openModalText));
      await tester.pumpAndSettle();

      expect(find.byType(GenericErrorDialog), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('showBookDetailDialog shows BookDetailDialog with the given book', (tester) async {
      final mockBook = MockBookGeneric();

      when(() => mockBook.key).thenReturn('test_key');
      when(() => mockBook.title).thenReturn('Test Title');

      when(() => mockBooksRepository.fetchBookDetail('test_key')).thenAnswer(
            (_) async => const BookDetail(
          key: 'test_key',
          title: 'Test Title',
          description: 'Test Description',
        ),
      );

      await tester.pumpWidget(
        buildTestableWidget(
          onTap: (context) => DialogUtilities.showBookDetailDialog(
            context,
            book: mockBook,
          ),
        ),
      );

      await tester.tap(find.text(_openModalText));
      await tester.pumpAndSettle();

      expect(find.byType(BookDetailDialog), findsOneWidget);

      final dialogWidget = tester.widget<BookDetailDialog>(find.byType(BookDetailDialog));
      expect(dialogWidget.bookGeneric, equals(mockBook));
    });

    testWidgets('showShelfBookDetail shows BookDatesDialog with the given saved book', (tester) async {
      final mockSavedBook = MockSavedBook();

      when(() => mockSavedBook.title).thenReturn('Saved Title');
      when(() => mockSavedBook.authorName).thenReturn(['Author']);
      when(() => mockSavedBook.startDate).thenReturn(null);
      when(() => mockSavedBook.endDate).thenReturn(null);
      when(() => mockSavedBook.savedAt).thenReturn(DateTime.now());

      await tester.pumpWidget(
        buildTestableWidget(
          onTap: (context) => DialogUtilities.showShelfBookDetail(
            context,
            book: mockSavedBook,
          ),
        ),
      );

      await tester.tap(find.text(_openModalText));
      await tester.pumpAndSettle();

      expect(find.byType(BookDatesDialog), findsOneWidget);

      final dialogWidget = tester.widget<BookDatesDialog>(find.byType(BookDatesDialog));
      expect(dialogWidget.book, equals(mockSavedBook));
    });

    testWidgets('showShelfSortingDialog provides the ShelfBloc to ShelfSortDialog', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          bloc: mockShelfBloc,
          onTap: (context) => DialogUtilities.showShelfSortingDialog(context),
        ),
      );

      await tester.tap(find.text(_openModalText));
      await tester.pumpAndSettle();

      expect(find.byType(ShelfSortDialog), findsOneWidget);

      final dialogContext = tester.element(find.byType(ShelfSortDialog));
      expect(BlocProvider.of<ShelfBloc>(dialogContext), equals(mockShelfBloc));
    });
  });
}