import 'package:flutter/material.dart';
import 'package:memento/theme.dart';

/// A custom horizontal divider widget with default styling consistent with app themes.
///
/// Wraps Flutter's [Divider] to provide standard fallback colors and custom thickness control.
class CustomHorizontalDivider extends StatelessWidget {
  final Color? dividerColor;
  final double dividerThickness;

  const CustomHorizontalDivider({
    this.dividerColor,
    this.dividerThickness = 1,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveDividerColor = dividerColor ?? AppThemes.unselectedItemColor.withValues(alpha: 0.8);

    return Divider(
      color: effectiveDividerColor,
      thickness: dividerThickness,
    );
  }
}
