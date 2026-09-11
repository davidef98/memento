import 'package:flutter/cupertino.dart';
import 'package:memento/theme.dart';

/// A wrapper widget that applies a customized [RawScrollbar] to a scrollable child.
///
/// Ensures uniform scrollbar styling (thickness, rounded corners, thumb color)
/// across both iOS and Android platforms when attached to a [ScrollController].
class CustomScrollbar extends StatelessWidget {
  /// The scrollable target widget wrapped by this scrollbar.
  final Widget child;

  /// Custom color for the scrollbar thumb indicator.
  /// Defaults to semi-transparent [AppThemes.secondaryColor] if null.
  final Color? thumbColor;

  /// Thickness of the scrollbar thumb in logical pixels. Defaults to 4.5.
  final double thickness;

  /// Corner radius of the scrollbar thumb. Defaults to `Radius.circular(8.0)`.
  final Radius radius;

  /// Whether the scrollbar thumb should remain permanently visible even when idling.
  final bool isAlwaysVisible;

  /// The [ScrollController] attached to both this scrollbar and the scrollable [child].
  final ScrollController controller;

  const CustomScrollbar({
    super.key,
    required this.child,
    this.thumbColor,
    this.thickness = 4.5,
    this.radius = const Radius.circular(8.0),
    this.isAlwaysVisible = false,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveThumbColor = thumbColor ?? AppThemes.secondaryColor.withValues(alpha:0.5);

    return RawScrollbar(
      thumbVisibility: isAlwaysVisible,
      thickness: thickness,
      radius: radius,
      thumbColor: effectiveThumbColor,
      controller: controller,
      child: child,
    );
  }
}
