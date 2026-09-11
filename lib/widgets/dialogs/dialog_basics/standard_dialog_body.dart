import 'package:flutter/cupertino.dart';

import '../../../theme.dart';

/// A standardized layout block for modal dialog body content.
///
/// Presents a descriptive text message above an illustrative central icon with configurable
/// spacing, typography styles, and theme colors.
class StandardDialogBody extends StatelessWidget {
  ///Text Parameters
  final String bodyText;
  final TextAlign textAlign;
  final TextStyle? textStyle;

  ///Icon Parameters
  final IconData bodyIcon;
  final Color? bodyIconColor;
  final double iconSize;

  ///Spacing Parameters
  final double spaceBetweenTextAndIconHeight;
  final double spaceAtEndHeight;

  const StandardDialogBody({
    super.key,

    ///Text Parameters
    required this.bodyText,
    this.textAlign = TextAlign.start,
    this.textStyle,

    ///Icon Parameters
    required this.bodyIcon,
    this.bodyIconColor,
    this.iconSize = 45,

    ///Spacing Parameters
    this.spaceBetweenTextAndIconHeight = 16,
    this.spaceAtEndHeight = 28,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle effectiveTextStyle = textStyle ?? UnifiedTextStyles.bodyText16;
    final Color effectiveBodyIconColor = bodyIconColor ?? AppThemes.secondaryColor;

    return Column(
      children: [
        Text(
          bodyText,
          textAlign: textAlign,
          style: effectiveTextStyle,
        ),
        SizedBox(
            height: spaceBetweenTextAndIconHeight
        ),
        Icon(
          bodyIcon,
          size: iconSize,
          color: effectiveBodyIconColor,
        ),
        SizedBox(
            height: spaceAtEndHeight
        ),
      ],
    );
  }
}
