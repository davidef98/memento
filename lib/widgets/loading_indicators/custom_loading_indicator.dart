import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memento/theme.dart';

import '../../utilities/utilities.dart';


/// A platform-adaptive loading indicator component wrapped with screen-reader accessibility semantics.
///
/// Renders a [CupertinoActivityIndicator] on iOS and a [CircularProgressIndicator]
/// on Android and other platforms, scaled consistently according to the specified [size].
///
/// For optimal layout symmetry on iOS, ensure [size] equals `2 * iOSRadius`.
class CustomLoadingIndicator extends StatelessWidget {
  /// Custom color for the spinner.
  ///
  /// Defaults to [AppThemes.secondaryColor] if null.
  final Color? color;

  /// The bounding box dimension (width and height) of the loader. Defaults to 24.0.
  final double size;

  /// Stroke width for the Android Material progress indicator. Defaults to 2.5.
  final double androidStrokeWidth;

  /// Custom spinner radius used strictly for the iOS Cupertino indicator.
  ///
  /// Defaults to `size / 2` if null.
  final double? iOSRadius;

  /// Accessibility label announced by screen readers. Defaults to `'Loading'`.
  final String semanticsLabel;

  const CustomLoadingIndicator({
    super.key,
    this.color,
    this.size = 24.0,
    this.androidStrokeWidth = 2.5,
    this.iOSRadius,
    this.semanticsLabel = 'Loading',
  });

  @override
  Widget build(BuildContext context) {
    final bool isIOS = context.isIOS;
    final Color effectiveColor = color ?? AppThemes.secondaryColor;

    return Semantics(
      label: semanticsLabel,
      value: 'In progress',
      readOnly: true,
      liveRegion: true,
      child: SizedBox(
        width: size,
        height: size,
        child: isIOS
            ? CupertinoActivityIndicator(
          color: effectiveColor,
          radius: iOSRadius ?? (size / 2),
        )
            : CircularProgressIndicator(
          strokeWidth: androidStrokeWidth,
          color: effectiveColor,
        ),
      ),
    );
  }
}
