import 'package:flutter/cupertino.dart';
import 'package:memento/theme.dart';

/// A centered top-handle indicator bar widget designed for modal bottom sheets and dialogs.
///
/// Provides a visual affordance indicating that a bottom sheet or modal dialog
/// can be dragged, resized, or dismissed.
class CustomDragHandleBar extends StatelessWidget {
  final Color? barColor;
  final double barRadius;
  final double? barWidth;
  final double? barHeight;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry barAlignment;

  const CustomDragHandleBar({
    this.barColor,
    this.barRadius = 10,
    this.barWidth,
    this.barHeight,
    this.padding = const EdgeInsets.only(top: 16),
    this.barAlignment = Alignment.topCenter,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final double effectiveWidth = barWidth ?? MediaQuery.of(context).size.width*0.1;
    final double effectiveHeight = barHeight ?? MediaQuery.of(context).size.width*0.012;
    final Color effectiveBarColor = barColor ??  AppThemes.unselectedItemColor;

    return Positioned.fill(
      child: Align(
        alignment: barAlignment,
        child: Padding(
          padding: padding,
          child: Container(
            width: effectiveWidth,
            height: effectiveHeight,
            decoration: BoxDecoration(
              color: effectiveBarColor,
              borderRadius: BorderRadius.circular(barRadius),
            ),
          ),
        ),
      ),
    );
  }
}
