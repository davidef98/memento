import 'package:shelf_api/shelf_api.dart';
import 'package:test/test.dart';

void main() {
  group('SavedBook', () {
    final savedAt = DateTime.utc(2026, 1, 15);
    final startDate = DateTime.utc(2026, 1, 16);
    final endDate = DateTime.utc(2026, 2, 1);

    final fullBook = SavedBook(
      id: '/works/OL1168083W',
      title: 'Nineteen Eighty-Four',
      authorName: const ['George Orwell'],
      coverI: 9267242,
      numberOfPagesMedium: 318,
      savedAt: savedAt,
      startDate: startDate,
      endDate: endDate,
    );

    test('supports value equality', () {
      expect(fullBook, equals(fullBook));
    });

    test('isCompleted is true when endDate is set', () {
      expect(fullBook.isCompleted, isTrue);
    });

    test('isCompleted is false when endDate is null', () {
      final book = SavedBook(
        id: '/works/OL1168083W',
        title: 'Nineteen Eighty-Four',
        savedAt: savedAt,
      );
      expect(book.isCompleted, isFalse);
    });

    group('copyWith', () {
      test('overrides startDate and endDate when provided', () {
        final base = SavedBook(
          id: '/works/OL1168083W',
          title: 'Nineteen Eighty-Four',
          savedAt: savedAt,
        );

        final updated = base.copyWith(
          startDate: startDate,
          endDate: endDate,
        );

        expect(updated.startDate, equals(startDate));
        expect(updated.endDate, equals(endDate));
        expect(updated.id, equals(base.id));
      });

      test('keeps existing values when arguments are omitted', () {
        final updated = fullBook.copyWith();
        expect(updated, equals(fullBook));
      });
    });

    group('fromJson / toJson', () {
      test('supports round-trip serialization with all fields', () {
        final json = fullBook.toJson();
        final roundTripped = SavedBook.fromJson(json);
        expect(roundTripped, equals(fullBook));
      });

      test(
        'supports round-trip serialization with optional fields omitted',
            () {
          final book = SavedBook(
            id: '/works/OL1168083W',
            title: 'Nineteen Eighty-Four',
            savedAt: savedAt,
          );
          final roundTripped = SavedBook.fromJson(book.toJson());
          expect(roundTripped, equals(book));
        },
      );

      test('includes optional fields as null in the JSON map', () {
        final book = SavedBook(
          id: '/works/OL1168083W',
          title: 'Nineteen Eighty-Four',
          savedAt: savedAt,
        );
        final json = book.toJson();
        expect(json.containsKey('startDate'), isTrue);
        expect(json['startDate'], isNull);
        expect(json.containsKey('endDate'), isTrue);
        expect(json['endDate'], isNull);
        expect(json.containsKey('authorName'), isTrue);
        expect(json['authorName'], isNull);
      });
    });
  });
}