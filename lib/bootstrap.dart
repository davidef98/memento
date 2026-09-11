import 'package:shared_preferences/shared_preferences.dart';

/// A bootstrap class responsible for asynchronously initializing core application dependencies
/// and services before the UI tree is rendered.
class AppBootstrap {
  AppBootstrap._({
    required this.prefs,
  });

  /// The initialized instance of [SharedPreferences] for local key-value persistence.
  final SharedPreferences prefs;

  /// Asynchronously initializes core services (such as [SharedPreferences])
  /// and returns a fully prepared [AppBootstrap] instance.
  static Future<AppBootstrap> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    return AppBootstrap._(
      prefs: prefs,
    );
  }
}