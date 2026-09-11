import 'package:books_api/books_api.dart';
import 'package:test/test.dart';

/// Response from the Open Library Works API (`/works/{key}.json`),
/// used as a fixture for these tests.
const _detail1984Json = <String, dynamic>{
  'key': '/works/OL1168083W',
  'title': 'Nineteen Eighty-Four',
  'description': {
    'type': '/type/text',
    'value': 'Nineteen Eighty-Four is a dystopian social science fiction '
        'novel by George Orwell.',
  },
  'subjects': ['Dystopias', 'Fiction', 'Political fiction'],
  'covers': [9267242, 8562242],
  'first_publish_date': '1949',
};

void main() {
  group('BookDetail', () {
    group('fromJson', () {
      test('parses a work detail response correctly', () {
        final detail = BookDetail.fromJson(_detail1984Json);

        expect(detail.key, equals('/works/OL1168083W'));
        expect(detail.title, equals('Nineteen Eighty-Four'));
        expect(detail.subjects, contains('Dystopias'));
        expect(detail.covers, equals([9267242, 8562242]));
        expect(detail.firstPublishDate, equals('1949'));
      });

      test(
        'normalizes description when it is a {type, value} object',
            () {
          final detail = BookDetail.fromJson(_detail1984Json);
          expect(
            detail.description,
            equals(
              'Nineteen Eighty-Four is a dystopian social science '
                  'fiction novel by George Orwell.',
            ),
          );
        },
      );

      test('normalizes description when it is a plain string', () {
        final json = <String, dynamic>{
          'key': '/works/OL166894W',
          'title': 'Crime and Punishment',
          'description': 'A simple plain-string description.',
        };
        final detail = BookDetail.fromJson(json);
        expect(
          detail.description,
          equals('A simple plain-string description.'),
        );
      });

      test('description is null when absent', () {
        final json = <String, dynamic>{
          'key': '/works/OL166894W',
          'title': 'Crime and Punishment',
        };
        final detail = BookDetail.fromJson(json);
        expect(detail.description, isNull);
      });

      test('handles missing optional fields', () {
        final json = <String, dynamic>{
          'key': '/works/OL166894W',
          'title': 'Crime and Punishment',
        };
        final detail = BookDetail.fromJson(json);
        expect(detail.subjects, isNull);
        expect(detail.covers, isNull);
        expect(detail.firstPublishDate, isNull);
      });
    });

    group('toJson / round-trip', () {
      test('supports round-trip serialization', () {
        final detail = BookDetail.fromJson(_detail1984Json);
        final roundTripped = BookDetail.fromJson(detail.toJson());

        expect(roundTripped, equals(detail));
      });

      test('serialized description is a plain string, not an object', () {
        final detail = BookDetail.fromJson(_detail1984Json);
        final json = detail.toJson();

        expect(json['description'], isA<String>());
      });
    });

    group('equality', () {
      test('two details with the same fields are equal', () {
        final a = BookDetail.fromJson(_detail1984Json);
        final b = BookDetail.fromJson(_detail1984Json);
        expect(a, equals(b));
      });
    });
  });
}