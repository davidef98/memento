import 'package:flutter/material.dart';
import '../../../../../../theme.dart';

/// Centralized configuration class defining common aesthetic and functional
/// properties for dialogs and modal bottom sheets across the application.
class DialogConfig {
  /// Standard shape applied to modal dialogs and bottom sheets, featuring
  /// rounded top corners with a radius of 12.
  static RoundedRectangleBorder shape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
        top: Radius.circular(12)
    ),
  );

  /// Resolves the standard background color for dialog containers using [AppThemes].
  static Color backgroundColor(BuildContext context) {
    return AppThemes.whiteBackground.withValues(alpha: 0.9);
  }

  /// Flag specifying whether the dialog should be pushed onto the root navigation stack.
  ///
  /// Defaults to `true` to ensure dialogs render above nested navigator stacks.
  static bool useRootNavigator = true;

  /// Flag specifying whether modal bottom sheets can extend full-height when content expands.
  ///
  /// Defaults to `true`.
  static bool isScrollControlled = true;
}
