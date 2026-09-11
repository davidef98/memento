import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memento/theme.dart';

import '../../../../utilities/utilities.dart';

/// A platform-adaptive back button component for navigation bars and headers.
///
/// Automatically presents a [CupertinoNavigationBarBackButton] on iOS or an [IconButton]
/// with a Material back arrow on Android and other platforms.
class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({
    super.key,
    this.showBackButton = true,
    this.backButtonIconColor,
    this.onBackPressed,
  });

  /// Control parameter
  final bool showBackButton;

  /// Layout
  final Color? backButtonIconColor;

  /// Callback
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    if (!showBackButton) return const SizedBox.shrink();

    final isIOS = context.isIOS;
    final effectiveColor = backButtonIconColor ?? AppThemes.secondaryColor;
    final onPop = onBackPressed ?? () => GoRouter.of(context).pop();

    return isIOS
        ? CupertinoNavigationBarBackButton(
      color: effectiveColor,
      onPressed: onPop,
    )
        : IconButton(
      icon: const Icon(Icons.arrow_back),
      color: effectiveColor,
      onPressed: onPop,
    );
  }
}