import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memento/theme.dart';

import '../../../l10n/app_localizations.dart';
import '../../../widgets/loading_indicators/custom_loading_indicator.dart';
import 'screens_content.dart';

///This widget can be used as a sliver inside a CustomScrollView to substitute
///the screen content during the loading of the UI
class LoadingContent extends StatelessWidget {
  ///Loading Indicators Parameters
  final double cupertinoActivityIndicatorRadius;
  final Color? loadingIndicatorsColor;
  final double sizedBoxSize;
  final double androidStrokeWidth;

  ///Text Parameters
  final TextStyle? textStyle;
  final TextAlign textAlign;

  const LoadingContent({
    super.key,

    ///Loading Indicators Parameters
    this.cupertinoActivityIndicatorRadius = 16,
    this.loadingIndicatorsColor,
    this.androidStrokeWidth = 2.5,
    this.sizedBoxSize = 28,

    ///Text Parameters
    this.textStyle,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTextStyle = textStyle ?? UnifiedTextStyles.bodyText16;
    final Color effectiveLoadingIndicatorsColor = loadingIndicatorsColor ?? AppThemes.secondaryColor;

    return ScreensContent(
      hasScrollBody: false,
      firstWidgetContent: CustomLoadingIndicator(
        iOSRadius: cupertinoActivityIndicatorRadius,
        color: effectiveLoadingIndicatorsColor,
        androidStrokeWidth: androidStrokeWidth,
        size: sizedBoxSize,
      ),
      secondWidgetContent: Text(
        AppLocalizations.of(context)!.loadingContent,
        style: effectiveTextStyle,
        textAlign: textAlign,
      ),
    );
  }
}
