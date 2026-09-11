// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:memento/functionalities/app/language_cubit/language_cubit.dart';

void main() {
  group('LanguageState', () {
    group('LanguageInitial', () {
      test('supports value equality', () {
        expect(
          LanguageInitial(),
          equals(LanguageInitial()),
        );
      });

      test('props are correct', () {
        expect(
          LanguageInitial().props,
          equals(<Object?>[]),
        );
      });
    });

    group('LanguageLoaded', () {
      test('supports value equality', () {
        expect(
          LanguageLoaded(Locale('en')),
          equals(LanguageLoaded(Locale('en'))),
        );
      });

      test('props are correct', () {
        expect(
          LanguageLoaded(Locale('it')).props,
          equals(<Object?>[
            Locale('it'),
          ]),
        );
      });
    });
  });
}