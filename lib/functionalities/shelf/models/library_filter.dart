import 'package:shelf_api/shelf_api.dart';
import 'saved_book_extension.dart';

enum LibraryFilter { all, notStarted, inProgress, finished }

extension LibraryFilterX on LibraryFilter {
  bool apply(SavedBook book) {
    switch (this) {
      case LibraryFilter.all:
        return true;
      case LibraryFilter.notStarted:
        return book.readingStatus == ReadingStatus.notStarted;
      case LibraryFilter.inProgress:
        return book.readingStatus == ReadingStatus.inProgress;
      case LibraryFilter.finished:
        return book.readingStatus == ReadingStatus.finished;
    }
  }

  Iterable<SavedBook> applyAll(Iterable<SavedBook> books) {
    return books.where(apply);
  }
}