import 'package:app_settings_repository/app_settings_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  final LanguageRepository _languageRepository;

  LanguageCubit({required languageRepository}) : _languageRepository = languageRepository,
        super(LanguageInitial());

  Future<void> loadLanguage() async {
    final languageCode = await _languageRepository.loadLocale();
    if (languageCode == null) {
      final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;

      final defaultLocale =
      systemLocale.languageCode == 'it'
          ? const Locale('it')
          : const Locale('en');

      emit(LanguageLoaded(defaultLocale));
    } else {
      emit(LanguageLoaded(Locale(languageCode)));
    }
  }

  Future<void> changeLanguage(Locale locale) async {
    await _languageRepository.saveLocale(locale.languageCode);
    emit(LanguageLoaded(locale));
  }
}
