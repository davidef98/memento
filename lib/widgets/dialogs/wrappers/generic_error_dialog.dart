import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memento/l10n/app_localizations.dart';
import 'package:memento/theme.dart';
import 'package:memento/utilities/utilities.dart';

import '../dialog_basics/dialog_structure.dart';
import '../dialog_basics/standard_dialog_body.dart';

/// A reusable dialog component used to present generic error messages to the user.
///
/// Wraps a [StandardDialogBody] inside a [DialogStructure] with platform-adaptive
/// warning icons and warning styling from [AppThemes].
class GenericErrorDialog extends StatelessWidget {
  final String errorMessage;

  const GenericErrorDialog({
    required this.errorMessage,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final bool isIOS = context.isIOS;
    final IconData bodyIcon = isIOS ? CupertinoIcons.exclamationmark_circle_fill : Icons.error;

    return DialogStructure(
      title: AppLocalizations.of(context)!.errorModalTitle,
      titleColor: AppThemes.accentColor1,
      bodyContent: [
        StandardDialogBody(
            bodyIcon: bodyIcon,
            bodyIconColor: AppThemes.accentColor1,
            bodyText: errorMessage
        )
      ],
    );
  }
}

