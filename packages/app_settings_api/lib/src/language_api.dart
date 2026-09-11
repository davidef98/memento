/// An abstract data provider interface defining operations for persisting
/// and retrieving the user's preferred application locale.
abstract class LanguageApi {
  const LanguageApi();

  /// Saves user's language preference
  Future<void> saveLocale(String locale);

  /// Reads user's language preference
  Future<String?> loadLocale();
}