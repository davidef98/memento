import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:memento/theme.dart';

import '../dialog_sub_widgets/custom_dialog_header.dart';
import 'custom_horizontal_divider.dart';

/// A structural layout wrapper for modal bottom sheets and dialog windows.
///
/// Combines a [CustomDialogHeader] (containing a drag bar and close button), a styled title with
/// a divider, and an unrolled list of child body widgets enclosed safely within [SafeArea].
class DialogStructure extends StatelessWidget {
  ///Title Parameters
  final String title;
  final Color? titleColor;

  final List<Widget> bodyContent;

  /// An optional asynchronous callback passed down to the header close button,
  /// executed immediately before popping the modal navigation context.
  final FutureOr<void> Function()? closingButtonFunction;

  const DialogStructure({
    super.key,

    ///Title Parameters
    required this.title,
    this.titleColor,

    required this.bodyContent,

    this.closingButtonFunction,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveTitleColor = titleColor ?? AppThemes.secondaryColor;
    return SafeArea(
      child:
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomDialogHeader(
            closingButtonFunction: closingButtonFunction,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Text(
                  title,
                  style: UnifiedTextStyles.headline20.copyWith(color: effectiveTitleColor),
                ),
                const CustomHorizontalDivider(),
                const SizedBox(height: 8,),
                ...bodyContent,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
