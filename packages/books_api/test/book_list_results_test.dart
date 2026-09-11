import 'package:books_api/books_api.dart';
import 'package:test/test.dart';

/// Real response from the Open Library Search API
/// (`/search.json?q=1984&fields=...`), used as a fixture for these tests.
const _search1984Json = <String, dynamic>{
  'numFound': 77137,
  'start': 0,
  'numFoundExact': true,
  'num_found': 77137,
  'documentation_url': 'https://openlibrary.org/dev/docs/api/search',
  'q': '1984',
  'offset': null,
  'docs': [
    {
      'author_name': ['George Orwell'],
      'cover_i': 9267242,
      'first_publish_year': 1949,
      'key': '/works/OL1168083W',
      'number_of_pages_median': 318,
      'title': 'Nineteen Eighty-Four',
    },
    {
      'author_name': ['George Orwell'],
      'cover_i': 10524365,
      'first_publish_year': 1978,
      'key': '/works/OL1167981W',
      'number_of_pages_median': 372,
      'title': 'Animal Farm / Nineteen Eighty-Four',
    },
    {
      'author_name': ['Michael Dean', 'George Orwell'],
      'cover_i': 8745958,
      'first_publish_year': 2003,
      'key': '/works/OL11326416W',
      'number_of_pages_median': 72,
      'title': '1984 (adaptation)',
    },
    {
      'author_name': ['George Orwell', 'AmÃ©lie Audiberti'],
      'cover_i': 14351142,
      'first_publish_year': 2021,
      'key': '/works/OL30827457W',
      'title': '1984',
    },
    {
      'author_name': ['Spark Publishing', 'SparkNotes'],
      'cover_i': 853463,
      'first_publish_year': 2003,
      'key': '/works/OL14905934W',
      'number_of_pages_median': 75,
      'title': 'SparkNotes for 1984 by George Orwell',
    },
    {
      'author_name': ['Anthony Burgess', 'Anthony Burgess'],
      'cover_i': 6640240,
      'first_publish_year': 1978,
      'key': '/works/OL1386730W',
      'number_of_pages_median': 272,
      'title': '1985',
    },
    {
      'author_name': ['Robert Owens'],
      'first_publish_year': 1963,
      'key': '/works/OL1168186W',
      'title': "George Orwell's 1984",
    },
    {
      'author_name': ["Louis L'Amour", "Louis L'amour"],
      'cover_i': 5298687,
      'first_publish_year': 1796,
      'key': '/works/OL51063W',
      'number_of_pages_median': 155,
      'title': 'Brionne',
    },
    {
      'author_name': ['George Orwell', 'Fido Nesti'],
      'cover_i': 10502178,
      'first_publish_year': 1984,
      'key': '/works/OL23745689W',
      'number_of_pages_median': 256,
      'title': '1984',
    },
    {
      'author_name': ['Jean Fritz'],
      'cover_i': 446320,
      'first_publish_year': 1969,
      'key': '/works/OL1931487W',
      'number_of_pages_median': 47,
      'title': "George Washington's Breakfast",
    },
  ],
};

void main() {
  group('BookListResults', () {
    group('fromJson', () {
      test('parses the "1984" search response correctly', () {
        final results = BookListResults.fromJson(_search1984Json);

        expect(results.numFound, equals(77137));
        expect(results.start, equals(0));
        expect(results.numFoundExact, isTrue);
        expect(results.docs, hasLength(10));
      });

      test('parses each doc as a BookGeneric', () {
        final results = BookListResults.fromJson(_search1984Json);

        final first = results.docs.first;
        expect(first.key, equals('/works/OL1168083W'));
        expect(first.title, equals('Nineteen Eighty-Four'));
        expect(first.authorName, equals(['George Orwell']));
        expect(first.coverI, equals(9267242));
        expect(first.firstPublishYear, equals(1949));
        expect(first.numberOfPagesMedium, equals(318));
      });

      test('handles docs with missing optional fields', () {
        final results = BookListResults.fromJson(_search1984Json);

        final noPageCount = results.docs.firstWhere(
              (doc) => doc.key == '/works/OL30827457W',
        );
        expect(noPageCount.numberOfPagesMedium, isNull);

        final minimalDoc = results.docs.firstWhere(
              (doc) => doc.key == '/works/OL1168186W',
        );
        expect(minimalDoc.coverI, isNull);
        expect(minimalDoc.numberOfPagesMedium, isNull);
      });

      test('ignores fields not modeled by BookListResults', () {
        expect(
              () => BookListResults.fromJson(_search1984Json),
          returnsNormally,
        );
      });
    });

    group('equality', () {
      test('two results with the same docs are equal', () {
        final a = BookListResults.fromJson(_search1984Json);
        final b = BookListResults.fromJson(_search1984Json);
        expect(a, equals(b));
      });
    });
  });
}