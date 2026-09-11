import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memento/l10n/app_localizations.dart';

import '../../../../theme.dart';
import '../../utilities/utilities.dart';

/// A platform-adaptive placeholder widget displayed when a network image fails to load.
///
/// Renders an error icon ([CupertinoIcons.exclamationmark_circle_fill] on iOS, [Icons.error] on Android)
/// stacked vertically above a localized error text message.
class ImageNetworkError extends StatelessWidget {
  ///Icon Parameters
  final double iconSize;
  final Color? iconColor;

  ///Layout Parameters
  final double spaceBetweenHeight;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;

  ///Text Parameters
  final TextStyle? textStyle;
  final int maxLines;
  final TextOverflow textOverflow;
  final TextAlign textAlign;

  const ImageNetworkError({
    super.key,

    ///Icon Parameters
    this.iconSize = 24,
    this.iconColor,

    ///Layout Parameters
    this.spaceBetweenHeight = 4,
    this.mainAxisSize = MainAxisSize.min,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,

    ///Text Parameters
    this.textStyle,
    this.maxLines = 1,
    this.textOverflow = TextOverflow.ellipsis,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    final bool isIOS = context.isIOS;
    final Color effectiveIconColor = iconColor ?? AppThemes.accentColor1;
    final IconData iconData = isIOS ? CupertinoIcons.exclamationmark_circle_fill : Icons.error;

    return  Column(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Icon(
          iconData,
          color: effectiveIconColor,
          size: iconSize,
        ),

        SizedBox(height: spaceBetweenHeight),

        Text(
          AppLocalizations.of(context)!.imageError,
          overflow: textOverflow,
          maxLines: maxLines,
          style: textStyle ?? UnifiedTextStyles.badge12.copyWith(color: AppThemes.accentColor1),
          textAlign: textAlign,
        ),
      ],
    );
  }
}
