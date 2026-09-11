/// Representation of a navigation route containing its name and path.
class AppRouter {
  /// The internal identifier name for the route.
  final String name;

  /// The URL path path for the route.
  final String path;

  const AppRouter({
    required this.name,
    required this.path,
  });
}

/// Centralized registry of application route definitions.
///
/// Contains predefined static constants used for navigation mapping.
class Routers {

  /// Main shelf screen route (`/`).
  static const shelfScreen = AppRouter(name: '/', path: '/');

  /// Book search screen route (`/search`).
  static const searchScreen = AppRouter(name: 'searchScreen', path: '/search');
}