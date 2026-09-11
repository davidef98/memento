// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Memento';

  @override
  String get shelfTitle => 'Your Library';

  @override
  String get loadingContent => 'Loading...';

  @override
  String get emptyShelf =>
      'Your library is currently empty. \nAdd some titles!';

  @override
  String get errorClickHere => 'An error occurred. Click here to try again';

  @override
  String get searchPlaceHolder => 'Search...';

  @override
  String get noSearchResults =>
      'The search did not return any results. \nTry searching for something else';

  @override
  String get errorModalTitle => 'Error';

  @override
  String get italian => 'Italian';

  @override
  String get english => 'English';

  @override
  String get langAlertTitle => 'Select your language:';

  @override
  String get startSearching => 'Type something and start your search!';

  @override
  String get noDescriptionAvailable => 'The plot of this book is not available';

  @override
  String get addToShelf => 'Add to shelf';

  @override
  String get orderByAddedDate => 'Sort by date added:';

  @override
  String get ascendingOrder => 'From newest to oldest';

  @override
  String get descendingOrder => 'From oldest to newest';

  @override
  String get dateAdded => 'Date added';

  @override
  String get startReading => 'Start reading';

  @override
  String get notStartedYet => 'Hasn\'t started yet';

  @override
  String get endOfReading => 'End of reading';

  @override
  String get inProgress => 'In progress';

  @override
  String get imageError => 'Error';

  @override
  String get deleteFromShelf => 'Delete from shelf';

  @override
  String get alreadyInLibraryFailure => 'This book is already on your shelf';

  @override
  String get bookNotFoundFailure => 'Book not found on your shelf';

  @override
  String get removingFailure => 'Could not remove the book. Please try again';

  @override
  String get addingFailure => 'Could not add the book. Please try again';

  @override
  String get readingStatusNotStarted => 'Not started';

  @override
  String get readingStatusInProgress => 'In progress';

  @override
  String get readingStatusFinished => 'Finished';

  @override
  String get emptyFilterResults =>
      'No books found matching the selected filter';

  @override
  String get filterDialogTitle => 'Show:';

  @override
  String get filterAll => 'All books';

  @override
  String get filterNotStarted => 'Books to start';

  @override
  String get filterInProgress => 'Books in progress';

  @override
  String get filterFinished => 'Completed books';

  @override
  String get save => 'Save';
}
