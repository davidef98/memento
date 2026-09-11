import 'package:books_api/books_api.dart';
import 'package:test/test.dart';

void main() {
  group('BookGeneric', () {
    const key = '/works/OL1168083W';
    const title = 'Nineteen Eighty-Four';

    final fullJson = <String, dynamic>{
      'key': key,
      'title': title,
      'author_name': ['George Orwell'],
      'cover_i': 9267242,
      'first_publish_year': 1949,
      'number_of_pages_median': 318,
    };

    const fullBook = BookGeneric(
      key: key,
      title: title,
      authorName: ['George Orwell'],
      coverI: 9267242,
      firstPublishYear: 1949,
      numberOfPagesMedium: 318,
    );

    group('constructor', () {
      test('supports value equality', () {
        expect(fullBook, equals(fullBook));
        expect(
          const BookGeneric(key: key, title: title),
          equals(const BookGeneric(key: key, title: title)),
        );
      });

      test('two instances with different fields are not equal', () {
        expect(
          fullBook,
          isNot(equals(const BookGeneric(key: key, title: title))),
        );
      });
    });

    group('fromJson', () {
      test('returns correct BookGeneric when all fields are present', () {
        expect(BookGeneric.fromJson(fullJson), equals(fullBook));
      });

      test('returns correct BookGeneric when optional fields are missing',
              () {
            final json = <String, dynamic>{'key': key, 'title': title};
            expect(
              BookGeneric.fromJson(json),
              equals(const BookGeneric(key: key, title: title)),
            );
          });

      test('handles multiple authors', () {
        final json = <String, dynamic>{
          'key': key,
          'title': '1984 (adaptation)',
          'author_name': ['Michael Dean', 'George Orwell'],
        };
        final book = BookGeneric.fromJson(json);
        expect(book.authorName, hasLength(2));
        expect(book.authorName, contains('Michael Dean'));
      });
    });

    group('toJson', () {
      test('returns correct JSON map when all fields are present', () {
        expect(fullBook.toJson(), equals(fullJson));
      });

      test('includes optional fields as null when not provided', () {
        const book = BookGeneric(key: key, title: title);
        final json = book.toJson();

        expect(
          json,
          equals({
            'key': key,
            'title': title,
            'author_name': null,
            'cover_i': null,
            'first_publish_year': null,
            'number_of_pages_median': null,
          }),
        );
      });
    });

    test('supports round-trip serialization', () {
      final roundTripped = BookGeneric.fromJson(fullBook.toJson());
      expect(roundTripped, equals(fullBook));
    });
  });
}