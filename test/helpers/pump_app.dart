import 'package:books_repository/books_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:memento/l10n/app_localizations.dart';

class MockBooksRepository extends Mock implements BooksRepository {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
      Widget widget, {
        BooksRepository? booksRepository,
        List<BlocProvider>? providers,
      }) {
    // Base MaterialApp
    final app = MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: widget),
    );

    Widget wrappedWidget = providers != null && providers.isNotEmpty
        ? MultiBlocProvider(providers: providers, child: app)
        : app;

    // The real App does the same
    return pumpWidget(
      RepositoryProvider<BooksRepository>.value(
        value: booksRepository ?? MockBooksRepository(),
        child: wrappedWidget,
      ),
    );
  }
}