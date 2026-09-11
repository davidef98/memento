import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///This widget can be used as a sliver inside a CustomScrollView to substitute
///the screen content in a specific state of the UI
///such as loading or fetching failure for example
class ScreensContent extends StatelessWidget {

  final Widget firstWidgetContent;
  final Widget? secondWidgetContent;
  final bool hasScrollBody;

  ///Layout Parameters
  final MainAxisAlignment mainAxisAlignment;
  final double spaceBetween;

  const ScreensContent({
    super.key,

    required this.firstWidgetContent,
    this.secondWidgetContent,
    this.hasScrollBody = true,

    ///Layout Parameters
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.spaceBetween = 12,
  });

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: hasScrollBody,
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          firstWidgetContent,
          SizedBox(
              height: spaceBetween
          ),
          secondWidgetContent ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
