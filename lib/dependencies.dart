import 'package:app_settings_api/app_settings_api.dart';
import 'package:app_settings_repository/app_settings_repository.dart';
import 'package:books_api/books_api.dart';
import 'package:books_repository/books_repository.dart';
import 'package:open_library_books_api/open_library_books_api.dart';
import 'package:shared_preferences_app_settings_api/shared_preferences_app_settings_api.dart';
import 'package:shared_preferences_shelf_api/shared_preferences_shelf_api.dart';
import 'package:shelf_api/shelf_api.dart';

import 'bootstrap.dart';

/// A dependency injection container responsible for instantiating and wiring up
/// core application APIs and repositories using the provided [AppBootstrap] state.
class AppDependencies {
  AppDependencies._({
    required this.booksRepository,
    required this.languageRepository,
  });

  /// The repository responsible for managing book collections and shelf data.
  final BooksRepository booksRepository;

  /// The repository responsible for managing application language preferences.
  final LanguageRepository languageRepository;

  /// Asynchronously creates and configures all app-level dependencies,
  /// connecting local storage APIs to [bootstrap.prefs] and network data sources.
  static Future<AppDependencies> create(AppBootstrap bootstrap) async {
    final ShelfApi shelfApi = SharedPreferencesShelfApi(plugin: bootstrap.prefs);
    final LanguageApi languageApi = SharedPreferencesLanguageApi(plugin: bootstrap.prefs);

    /// Since this is the only API client in the project
    /// that interacts with the network, we will let it instantiate
    /// its own internal Dio client.
    /// Conversely, if we had multiple API clients,
    /// it would have been best practice to pass a single shared Dio instance
    /// to all of them in order to centralize network configurations.
    final BookApi booksApi = OpenLibraryBooksApi();

    final booksRepository = BooksRepository(
      bookApi: booksApi,
      shelfApi: shelfApi,
    );

    final languageRepository = LanguageRepository(languageApi: languageApi);

    return AppDependencies._(
      booksRepository: booksRepository,
      languageRepository: languageRepository
    );
  }
}