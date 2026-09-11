import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memento/l10n/app_localizations.dart';

import '../../../../theme.dart';
import '../../../utilities/utilities.dart';

/// A widget that presents a pair of sorting options for ascending and descending directions.
///
/// Displays two selectable rows with customizable labels, text styles, active check icons,
/// and platform-adaptive leading indicator icons.
class SortingRowButtons extends StatelessWidget {
  final String? ascLabel;
  final String? descLabel;
  final VoidCallback onAsc;
  final VoidCallback onDesc;
  final bool highlightAsc;
  final bool highlightDesc;
  final Color? activeCheckColor;
  final TextStyle? baseTextStyle;
  final TextStyle? highlightTextStyle;

  const SortingRowButtons({
    super.key,
    this.ascLabel,
    this.descLabel,
    required this.onAsc,
    required this.onDesc,
    required this.highlightAsc,
    required this.highlightDesc,
    this.activeCheckColor,
    this.baseTextStyle,
    this.highlightTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle effectiveBaseTextStyle =
        baseTextStyle ?? UnifiedTextStyles.bodyText16;
    final TextStyle effectiveHighlightTextStyle = highlightTextStyle ??
        UnifiedTextStyles.bodyText16.copyWith(fontWeight: FontWeight.bold);

    final Color checkColor = activeCheckColor ?? AppThemes.accentColor2;

    final String textAsc = ascLabel ?? AppLocalizations.of(context)!.ascendingOrder;
    final String textDesc = descLabel ?? AppLocalizations.of(context)!.descendingOrder;
    final bool isIOS = context.isIOS;
    final IconData leadingIconData = isIOS ? CupertinoIcons.circle_fill : Icons.circle_rounded;
    final IconData activeIconData = isIOS ? CupertinoIcons.checkmark_circle_fill : Icons.check_circle;

    final Icon leadingIcon = Icon(
      leadingIconData,
      color: AppThemes.secondaryColor,
      size: 8
    );

    final Icon trailingIcon = Icon(
      activeIconData,
      color: checkColor,
      size: 24,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Row(
            children: [
              leadingIcon,
              const SizedBox(width: 8),
              Text(
                textAsc,
                style: highlightAsc ? effectiveHighlightTextStyle : effectiveBaseTextStyle,
              ),
            ],
          ),
          trailing: highlightAsc
              ? trailingIcon
              : const SizedBox.shrink(),
          onTap: onAsc,
          selected: highlightAsc,
        ),


        ListTile(
          title: Row(
            children: [
              leadingIcon,
              const SizedBox(width: 8),
              Text(
                textDesc,
                style: highlightDesc ? effectiveHighlightTextStyle : effectiveBaseTextStyle,
              ),
            ],
          ),
          trailing: highlightDesc
              ? trailingIcon
              : const SizedBox.shrink(),
          onTap: onDesc,
          selected: highlightDesc,
        ),
      ],
    );
  }
}