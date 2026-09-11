import 'package:app_settings_repository/app_settings_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:memento/functionalities/app/language_cubit/language_cubit.dart';

class MockLanguageRepository extends Mock implements LanguageRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LanguageCubit', () {
    late LanguageRepository languageRepository;

    setUp(() {
      languageRepository = MockLanguageRepository();
    });

    LanguageCubit buildCubit() {
      return LanguageCubit(languageRepository: languageRepository);
    }

    group('constructor', () {
      test('works properly', () {
        expect(buildCubit, returnsNormally);
      });

      test('has correct initial state', () {
        expect(
          buildCubit().state,
          equals(LanguageInitial()),
        );
      });
    });

    group('loadLanguage', () {
      blocTest<LanguageCubit, LanguageState>(
        'emits LanguageLoaded with saved locale when repository returns locale',
        setUp: () {
          when(() => languageRepository.loadLocale())
              .thenAnswer((_) async => 'it');
        },
        build: buildCubit,
        act: (cubit) => cubit.loadLanguage(),
        expect: () => const [
          LanguageLoaded(Locale('it')),
        ],
        verify: (_) {
          verify(() => languageRepository.loadLocale()).called(1);
        },
      );

      blocTest<LanguageCubit, LanguageState>(
        'emits LanguageLoaded with fallback system locale when repository returns null',
        setUp: () {
          when(() => languageRepository.loadLocale())
              .thenAnswer((_) async => null);
        },
        build: buildCubit,
        act: (cubit) => cubit.loadLanguage(),
        expect: () {
          final systemLocale =
              WidgetsBinding.instance.platformDispatcher.locale;
          final expectedLocale = systemLocale.languageCode == 'it'
              ? const Locale('it')
              : const Locale('en');

          return [
            LanguageLoaded(expectedLocale),
          ];
        },
        verify: (_) {
          verify(() => languageRepository.loadLocale()).called(1);
        },
      );
    });

    group('changeLanguage', () {
      blocTest<LanguageCubit, LanguageState>(
        'saves locale in repository and emits LanguageLoaded',
        setUp: () {
          when(() => languageRepository.saveLocale(any()))
              .thenAnswer((_) async {});
        },
        build: buildCubit,
        act: (cubit) => cubit.changeLanguage(const Locale('en')),
        expect: () => const [
          LanguageLoaded(Locale('en')),
        ],
        verify: (_) {
          verify(() => languageRepository.saveLocale('en')).called(1);
        },
      );
    });
  });
}