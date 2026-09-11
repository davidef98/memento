import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'dart:io';

import 'routers.dart';
import '../functionalities/screens.dart';

/// Indicates whether the current platform is iOS.
final bool isIOS = Platform.isIOS;

/// Helper function to build a platform-adaptive route page.
///
/// Returns a [CupertinoPage] with iOS slide transitions on iOS,
/// or a standard [MaterialPage] on Android.
Page _buildPage(Widget child) {
  return isIOS
      ? CupertinoPage(child: child)
      : MaterialPage(child: child);
}

/// Central application router configured using [GoRouter].
///
/// Defines navigation routes for the main application screens (Shelf, Search)
/// with platform-adaptive page transition builders.
final router = GoRouter(
  routes: [

    /// Main shelf screen route.
    GoRoute(
      path: Routers.shelfScreen.path,
      name: Routers.shelfScreen.name,
      pageBuilder: (_, __) => _buildPage(const ShelfScreen()),
    ),

    /// Book search screen route.
    GoRoute(
      path: Routers.searchScreen.path,
      name: Routers.searchScreen.name,
      pageBuilder: (_, __) => _buildPage(const SearchScreen()),
    ),
  ]
);