import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memento/functionalities/shelf/bloc/shelf_bloc/shelf_bloc.dart';
import 'package:memento/l10n/app_localizations.dart';

import '../../../../theme.dart';
import '../../../utilities/utilities.dart';
import '../models/library_filter.dart';

/// A widget that presents a set of filter options for the user's shelf.
///
/// Displays four selectable rows with customizable labels, text styles, active check icons,
/// and platform-adaptive leading indicator icons.
class FilterRowButtons extends StatelessWidget {
  final Color? activeCheckColor;
  final TextStyle? baseTextStyle;
  final TextStyle? highlightTextStyle;

  const FilterRowButtons({
    super.key,
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

    final l10 = AppLocalizations.of(context)!;

    final bool isIOS = context.isIOS;
    final IconData leadingIconData = isIOS ? CupertinoIcons.circle_fill : Icons.circle_rounded;
    final IconData activeIconData = isIOS ? CupertinoIcons.checkmark_circle_fill : Icons.check_circle;

    final Icon leadingIcon = Icon(
      leadingIconData,
      color: AppThemes.secondaryColor,
      size: 8,
    );

    final Icon trailingIcon = Icon(
      activeIconData,
      color: checkColor,
      size: 24,
    );

    final filterOptions = [
      (label: l10.filterAll, filter: LibraryFilter.all),
      (label: l10.filterNotStarted, filter: LibraryFilter.notStarted),
      (label: l10.filterInProgress, filter: LibraryFilter.inProgress),
      (label: l10.filterFinished, filter: LibraryFilter.finished),
    ];

    return BlocBuilder<ShelfBloc, ShelfState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: filterOptions.map((option) {
            final bool isSelected = state.filter == option.filter;

            return ListTile(
              title: Row(
                children: [
                  leadingIcon,
                  const SizedBox(width: 8),
                  Text(
                    option.label,
                    style: isSelected
                        ? effectiveHighlightTextStyle
                        : effectiveBaseTextStyle,
                  ),
                ],
              ),
              trailing: isSelected ? trailingIcon : const SizedBox.shrink(),
              selected: isSelected,
              onTap: () {
                context
                    .read<ShelfBloc>()
                    .add(ShelfFilterChanged(option.filter));
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        );
      },
    );
  }
}