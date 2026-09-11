import 'package:shelf_api/shelf_api.dart';

/// Represents the reading progress status of a saved book.
enum ReadingStatus {
  notStarted,
  inProgress,
  finished,
}

/// Extension on [SavedBook] to evaluate its reading status based on reading dates.
extension SavedBookX on SavedBook {
  ReadingStatus get readingStatus {
    if (endDate != null) {
      return ReadingStatus.finished;
    } else if (startDate != null) {
      return ReadingStatus.inProgress;
    }
    return ReadingStatus.notStarted;
  }
}