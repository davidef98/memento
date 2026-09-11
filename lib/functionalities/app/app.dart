import 'package:app_settings_repository/app_settings_repository.dart';
import 'package:books_repository/books_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memento/functionalities/shelf/bloc/shelf_bloc/shelf_bloc.dart';
import 'package:memento/l10n/app_localizations.dart';
import 'package:memento/routing/router_config.dart';

import 'language_cubit/language_cubit.dart';

/// The root widget of the Memento application.
///
/// Sets up global dependency injection via [RepositoryProvider], registers global
/// BLoC/Cubit instances ([ShelfBloc], [LanguageCubit]), and provides dynamic locale
/// resolution and platform-adaptive app initialization ([CupertinoApp] vs [MaterialApp]).
class App extends StatelessWidget {
  const App({
    super.key,
    required this.booksRepository,
    required this.languageRepository,
  });

  /// Repository instance managing shelf books and persistence operations.
  final BooksRepository booksRepository;

  /// Repository instance managing user language settings and preferences.
  final LanguageRepository languageRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: booksRepository,
      child: MultiBlocProvider(
        providers: [
          /// Initializes the global shelf BLoC and starts listening to saved books updates.
          BlocProvider(
              create: (_) => ShelfBloc(
                  booksRepository: booksRepository
              )..add(ShelfSubscriptionRequested())
          ),

          /// Initializes the global language Cubit and fetches stored locale preferences.
          BlocProvider(
            create: (_) => LanguageCubit(
                languageRepository: languageRepository
            )..loadLanguage(),
          ),
        ],
        child: BlocBuilder<LanguageCubit, LanguageState>(
            builder: (context, state) {
              if(state is LanguageLoaded){
                return isIOS
                    ? CupertinoApp.router(
                  debugShowCheckedModeBanner: false,
                  title: 'Memento',
                  locale: state.locale,
                  routerDelegate: router.routerDelegate,
                  routeInformationParser:
                  router.routeInformationParser,
                  routeInformationProvider:
                  router.routeInformationProvider,
                  localizationsDelegates: AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  theme: const CupertinoThemeData(
                    primaryColor: CupertinoColors.activeBlue,
                  ),
                )
                    : MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  title: 'Memento',
                  locale: state.locale,
                  routerDelegate: router.routerDelegate,
                  routeInformationParser:
                  router.routeInformationParser,
                  routeInformationProvider:
                  router.routeInformationProvider,
                  localizationsDelegates: AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  theme: ThemeData(
                    useMaterial3: true,
                    colorSchemeSeed: Colors.deepPurple,
                  ),
                );
              } else{
                /// Fallback loader widget presented while reading initial locale settings.
                return const CircularProgressIndicator();
              }
            })
      ),
    );
  }
}