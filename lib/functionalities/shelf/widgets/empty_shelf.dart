import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utilities/utilities.dart';
import '../../../theme.dart';
import 'screens_content.dart';

///This widget can be used as a sliver inside a CustomScrollView to substitute
///the screen content has not result
class EmptyContent extends StatelessWidget {
  final bool hasScrollBody;

  ///Text Parameters
  final String message;
  final TextStyle? textStyle;
  final TextAlign textAlign;

  ///Icon Parameters
  final Color? iconColor;
  final double iconSize;

  const EmptyContent({
    super.key,

    this.hasScrollBody = true,

    ///Text Parameters
    required this.message,
    this.textStyle,
    this.textAlign = TextAlign.center,

    ///Icon Parameters
    this.iconColor,
    this.iconSize = 48,
  });

  @override
  Widget build(BuildContext context) {
    final bool isIOS = context.isIOS;
    final Color effectiveIconColor = iconColor ?? AppThemes.unselectedItemColor;

    final IconData iconData = isIOS
        ? CupertinoIcons.search
        : Icons.search;
    final effectiveTextStyle = textStyle ?? UnifiedTextStyles.bodyText16;

    return ScreensContent(
      hasScrollBody: hasScrollBody,
      firstWidgetContent: Icon(
        iconData,
        color: effectiveIconColor,
        size: iconSize,
      ),
      secondWidgetContent:
      Text(
        message,
        style: effectiveTextStyle,
        textAlign: textAlign,
      ),
    );
  }
}
