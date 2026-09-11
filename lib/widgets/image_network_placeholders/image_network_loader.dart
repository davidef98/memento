import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../theme.dart';
import '../loading_indicators/custom_loading_indicator.dart';

/// A styled placeholder widget displayed while a network image is loading.
///
/// Wraps a [CustomLoadingIndicator] inside a container with semi-transparent background
/// styling and right-side rounded borders.
class ImageNetworkLoader extends StatelessWidget {
  final double radius;
  final Color? indicatorColor;
  final double androidStrokeWidth;
  final double size;
  final Color? backgroundColor;

  const ImageNetworkLoader({
    super.key,
    this.radius = 12,
    this.indicatorColor,
    this.size = 24,
    this.androidStrokeWidth = 2.5,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveIndicatorColor =
        indicatorColor ?? AppThemes.secondaryColor;
    final Color effectiveBackgroundColor =
        backgroundColor ?? AppThemes.unselectedItemColor.withValues(alpha: 0.1);

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
      ),
      child: Center(
        child: CustomLoadingIndicator(
          iOSRadius: radius,
          androidStrokeWidth: androidStrokeWidth,
          size: size,
          color: effectiveIndicatorColor,
        ),
      ),
    );
  }
}