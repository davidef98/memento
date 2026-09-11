import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memento/theme.dart';

import 'custom_loading_indicator.dart';

/// A centered loading indicator widget typically rendered at the bottom of
/// scrollable lists during pagination or infinite scrolling.
///
/// Wraps a platform-adaptive [CustomLoadingIndicator] with configurable padding
/// and sizing constraints.
class BottomListLoader extends StatelessWidget {
  ///Layout Parameters
  final EdgeInsetsGeometry padding;
  final double sizedBoxDimension;
  final Color? indicatorColor;
  final double iOSRadius;
  final double androidStrokeWidth;

  const BottomListLoader({
    super.key,

    ///Layout Parameters
    this.padding = const EdgeInsets.only(bottom: 24, top: 8),
    this.sizedBoxDimension = 24,
    this.indicatorColor,
    this.iOSRadius = 12,
    this.androidStrokeWidth = 2.5,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveIndicatorColor = indicatorColor ?? AppThemes.secondaryColor;

    return Center(
      child: Padding(
        padding: padding,
        child: CustomLoadingIndicator(
          size: sizedBoxDimension,
          androidStrokeWidth: androidStrokeWidth,
          color: effectiveIndicatorColor,
          iOSRadius: iOSRadius,
        ),
      ),
    );
  }
}
