import 'package:flutter/material.dart';
import 'package:memento/functionalities/shelf/widgets/filter_row_buttons.dart';
import 'package:memento/widgets/dialogs/dialog_basics/dialog_basics.dart';

import '../../../l10n/app_localizations.dart';

class ShelfFilterDialog extends StatelessWidget {
  const ShelfFilterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return DialogStructure(
        title: AppLocalizations.of(context)!.filterDialogTitle,
        bodyContent: [
          FilterRowButtons(),
        ]
    );
  }
}
