import 'package:flutter/material.dart';

extension BuildContextUtils on BuildContext {
  /// Whether the app is running on iOS (as opposed to Android etc.).
  ///
  /// Useful for platform-specific UI
  bool get isIOS => Theme.of(this).platform == TargetPlatform.iOS;
}