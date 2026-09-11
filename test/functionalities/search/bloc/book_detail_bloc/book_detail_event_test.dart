// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:memento/functionalities/search/bloc/book_detail_bloc/book_detail_bloc.dart';

void main() {
  group('BookDetailEvent', () {
    group('FetchBook', () {
      test('supports value equality', () {
        expect(
          FetchBook('/works/OL1168083W'),
          equals(FetchBook('/works/OL1168083W')),
        );
      });

      test('props are correct', () {
        expect(
          FetchBook('/works/OL1168083W').props,
          equals(<Object?>[
            '/works/OL1168083W',
          ]),
        );
      });
    });
  });
}