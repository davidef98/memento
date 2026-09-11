import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memento/utilities/utilities.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme.dart';
import 'screens_content.dart';

///This widget can be used as a sliver inside a CustomScrollView to substitute
///the screen content during the fetch failure state
class ErrorContent extends StatelessWidget {
  final bool hasScrollBody;

  ///Function usually used to fetch again the content
  final VoidCallback onPressed;

  ///Layout
  final TextStyle? textStyle;
  final double iconSize;
  final Color? iconColor;

  const ErrorContent({
    super.key,

    this.hasScrollBody = true,

    ///Function usually used to fetch again the content
    required this.onPressed,
    this.textStyle,
    this.iconSize = 32,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveIconColor = iconColor ?? AppThemes.secondaryColor;
    final bool isIOS = context.isIOS;
    final IconData icon = isIOS ? CupertinoIcons.arrow_clockwise : Icons.change_circle_outlined;

    return ScreensContent(
      hasScrollBody: hasScrollBody,
      firstWidgetContent: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: 28,
            color: effectiveIconColor,
          )
      ),
      secondWidgetContent: Text(
        AppLocalizations.of(context)!.errorClickHere,
        style: UnifiedTextStyles.bodyText16,
      ),
    );
  }
}
