import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utilities/utilities.dart';
import '../../theme.dart';

/// A platform-adaptive scaffold component that wraps sliver scroll views or custom scroll layouts.
///
/// Uses [CupertinoPageScaffold] on iOS and [Scaffold] on Android and other platforms,
/// ensuring consistent background styling across the app.
class CustomScaffold extends StatelessWidget {
  /// The main scroll view content (typically a [CustomScrollView] or [CustomScrollbar])
  /// rendered within the scaffold body.
  final Widget customScrollView;

  /// Custom background color for the scaffold container.
  /// Defaults to [AppThemes.primaryColor] if null.
  final Color? backgroundColor;

  const CustomScaffold({
    super.key,
    required this.customScrollView,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isIOS = context.isIOS;
    final Color bg = backgroundColor ?? AppThemes.primaryColor;

    if (isIOS) {
      return Container(
        color: bg,
        child: CupertinoPageScaffold(
          backgroundColor: bg,
          child: customScrollView,
        ),
      );
    }

    return Container(
      color: bg,
      child: Scaffold(
        backgroundColor: bg,
        body: customScrollView,
      ),
    );
  }
}
