import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_app_settings_api/shared_preferences_app_settings_api.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('SharedPreferencesLanguageApi', () {
    late SharedPreferences plugin;

    setUp(() {
      plugin = MockSharedPreferences();
    });

    SharedPreferencesLanguageApi createSubject() {
      return SharedPreferencesLanguageApi(
        plugin: plugin,
      );
    }

    group('constructor', () {
      test('works properly', () {
        expect(
          createSubject,
          returnsNormally,
        );
      });
    });

    group('loadLocale', () {
      test('returns stored locale string when present', () async {
        const locale = 'it';
        when(() => plugin.getString(any())).thenReturn(locale);

        final subject = createSubject();

        expect(await subject.loadLocale(), equals(locale));
        verify(() => plugin.getString('selected_locale')).called(1);
      });

      test('returns null when no locale is stored', () async {
        when(() => plugin.getString(any())).thenReturn(null);

        final subject = createSubject();

        expect(await subject.loadLocale(), isNull);
        verify(() => plugin.getString('selected_locale')).called(1);
      });
    });

    group('saveLocale', () {
      test('persists locale string in shared preferences', () async {
        const locale = 'en';
        when(() => plugin.setString(any(), any()))
            .thenAnswer((_) async => true);

        final subject = createSubject();

        await expectLater(subject.saveLocale(locale), completes);
        verify(() => plugin.setString('selected_locale', locale)).called(1);
      });
    });
  });
}