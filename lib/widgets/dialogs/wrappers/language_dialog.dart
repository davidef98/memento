import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memento/l10n/app_localizations.dart';

import '../../../functionalities/app/language_cubit/language_cubit.dart';
import '../../buttons/svg_button.dart';
import '../dialog_basics/dialog_structure.dart';

/// A dialog component that allows users to select and switch the application locale.
///
/// Features flag options for supported languages (Italian, English) and updates
/// application locale state using [LanguageCubit].
class LanguageDialog extends StatelessWidget {
  const LanguageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return DialogStructure(
        title: AppLocalizations.of(context)!.langAlertTitle,
        bodyContent: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              /// Italian language selection button
              SvgButton(
                icon: SvgPicture.asset(
                  'assets/italy.svg',
                  height: 50,
                  width: 50,
                ),
                text: AppLocalizations.of(context)!.italian,
                onPressed: () {
                  context.read<LanguageCubit>().changeLanguage(
                      const Locale('it'));
                  Navigator.of(context).pop();
                },
              ),
              /// English language selection button
              SvgButton(
                icon: SvgPicture.asset(
                  'assets/uk.svg',
                  height: 50,
                  width: 50,
                ),
                text: AppLocalizations.of(context)!.english,
                onPressed: () {
                  context.read<LanguageCubit>().changeLanguage(
                      const Locale('en'));
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ]);
  }
}


