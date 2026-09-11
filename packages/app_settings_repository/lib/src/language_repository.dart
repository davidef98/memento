import 'package:app_settings_api/app_settings_api.dart';

/// A repository that coordinates language preference operations between the application
/// business logic and the underlying [LanguageApi] data provider.
class LanguageRepository {
  const LanguageRepository({required LanguageApi languageApi}) : _languageApi = languageApi;

  final LanguageApi _languageApi;

  /// Saves the specified [locale] string using the underlying storage API.
  Future<void> saveLocale(String locale) async {
    await _languageApi.saveLocale(locale);
  }

  /// Loads and returns the saved locale string from the data source,
  /// or returns `null` if none exists.
  Future<String?> loadLocale() async {
    return _languageApi.loadLocale();
  }
}
