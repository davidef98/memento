import 'package:flutter/material.dart';
import 'package:memento/theme.dart';

/// A reusable title widget used across app bars and header sections.
///
/// Applies the standard [UnifiedTextStyles.scaffoldTitle] typography style
/// with support for custom text color overrides.
class TitleWidget extends StatelessWidget {
  final String title;
  final Color? titleColor;

  const TitleWidget({
    super.key,

    required this.title,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveTitleColor = titleColor ?? AppThemes.secondaryColor;

    return Text(
      title,
      style: UnifiedTextStyles.scaffoldTitle.copyWith(color: effectiveTitleColor),
    );
  }
}
