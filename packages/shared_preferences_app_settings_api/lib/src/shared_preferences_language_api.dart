import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_settings_api/app_settings_api.dart';

/// A [SharedPreferences]-backed implementation of the [LanguageApi] interface.
///
/// Persists and retrieves the user's selected language locale string locally
/// using the `shared_preferences` key-value store plugin.
class SharedPreferencesLanguageApi extends LanguageApi {
  const SharedPreferencesLanguageApi({
    required SharedPreferences plugin,
  }) : _plugin = plugin;

  final SharedPreferences _plugin;

  /// The storage key used to persist the selected locale string.
  static const _key = 'selected_locale';

  @override
  Future<String?> loadLocale() async {
    return _plugin.getString(_key);
  }

  @override
  Future<void> saveLocale(String locale) async {
    await _plugin.setString(_key, locale);
  }
}