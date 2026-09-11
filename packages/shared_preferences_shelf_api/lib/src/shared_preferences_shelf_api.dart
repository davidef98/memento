import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelf_api/shelf_api.dart';

/// {@template local_storage_shelf_api}
/// A Flutter implementation of the [ShelfApi] that uses local storage.
/// {@endtemplate}
class SharedPreferencesShelfApi extends ShelfApi {
  /// {@macro local_storage_shelf_api}
  SharedPreferencesShelfApi({
    required SharedPreferences plugin})
      : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;

  late final _booksStreamController = BehaviorSubject<List<SavedBook>>.seeded(
    const [],
  );

  /// The key used for storing the saved books locally.
  ///
  /// This is only exposed for testing and shouldn't be used by
  /// consumers of this library.
  @visibleForTesting
  static const kBooksCollectionKey = '__books_collection_key__';

  String? _getValue(String key) => _plugin.getString(key);

  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  void _init() {
    final booksJson = _getValue(kBooksCollectionKey);
    if (booksJson == null) return;

    final books = List<Map<dynamic, dynamic>>.from(
      json.decode(booksJson) as List,
    )
        .map(
          (jsonMap) => SavedBook.fromJson(Map<String, dynamic>.from(jsonMap)),
    )
        .toList();

    _booksStreamController.add(books);
  }

  @override
  Stream<List<SavedBook>> getBooks({
    LibrarySortOrder sortOrder = LibrarySortOrder.savedAtDescending,
  }) {
    return _booksStreamController.map((books) {
      switch (sortOrder) {
        case LibrarySortOrder.savedAtAscending:
          return books.toList();
        case LibrarySortOrder.savedAtDescending:
          return books.reversed.toList();
      }
    }).asBroadcastStream();
  }

  @override
  Future<void> saveBook(SavedBook book) {
    final books = [..._booksStreamController.value];
    final bookIndex = books.indexWhere((b) => b.id == book.id);

    if (bookIndex >= 0) {
      books[bookIndex] = book;
    } else {
      books.add(book);
    }

    _booksStreamController.add(books);
    return _setValue(kBooksCollectionKey, json.encode(books));
  }

  @override
  Future<void> deleteBook(String id) async {
    final books = [..._booksStreamController.value];
    final bookIndex = books.indexWhere((b) => b.id == id);

    if (bookIndex == -1) {
      throw BookNotFoundException(id);
    }

    books.removeAt(bookIndex);
    _booksStreamController.add(books);
    return _setValue(kBooksCollectionKey, json.encode(books));
  }

  @override
  Future<void> close() {
    return _booksStreamController.close();
  }
}