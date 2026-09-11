import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memento/utilities/utilities.dart';

import '../../../theme.dart';

/// A platform-adaptive closing button component used within dialogs
/// or modal bottom sheets.
///
/// Renders an "X" icon ([CupertinoIcons.xmark_circle_fill] on iOS, [Icons.close] on Android)
/// aligned to the top-right corner. Automatically handles closing the current navigation route.
class CustomClosingButton extends StatelessWidget {
  ///Icon Parameters
  final Color? iconColor;
  final double iconSize;
  final EdgeInsetsGeometry iconPadding;

  /// An optional asynchronous callback executed immediately before popping the navigator.
  ///
  /// Useful for triggering side effects or saving state before the modal closes.
  /// It can handle navigation or other usefully stuff.
  final FutureOr<void> Function()? onClose;

  const CustomClosingButton({
    super.key,

    this.iconColor,
    this.iconSize = 24,
    this.iconPadding = const EdgeInsetsGeometry.fromLTRB(0, 4, 4, 0),

    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final bool isIOS = context.isIOS;
    final IconData effectiveIconData = isIOS ? CupertinoIcons.xmark_circle_fill : Icons.close;
    final Color effectiveIconColor = iconColor ?? AppThemes.secondaryColor.withValues(alpha: 0.8);

    return Padding(
      padding: iconPadding,
      child: Align(
        alignment: Alignment.centerRight,
        child: IconButton(
            onPressed: () async {
              if (onClose != null) {
                await onClose!();
              }
              if (!context.mounted) return;

              Navigator.of(context).pop();
            },
            icon: Icon(
                effectiveIconData
            ),
          color: effectiveIconColor,
          iconSize: iconSize,
        ),
        ),
    );
  }
}

