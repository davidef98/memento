// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Memento';

  @override
  String get shelfTitle => 'La tua Libreria';

  @override
  String get loadingContent => 'Caricamento in corso...';

  @override
  String get emptyShelf =>
      'Al momento la tua biblioteca è vuota. \nAggiungi dei titoli!';

  @override
  String get errorClickHere =>
      'Si è verificato un errore, clicca qui per riprovare';

  @override
  String get searchPlaceHolder => 'Cerca...';

  @override
  String get noSearchResults =>
      'La ricerca non ha restituito alcun risulta. \nCerca qualcosa di diverso';

  @override
  String get errorModalTitle => 'Errore';

  @override
  String get italian => 'Italiano';

  @override
  String get english => 'Inglese';

  @override
  String get langAlertTitle => 'Seleziona la tua lingua:';

  @override
  String get startSearching => 'Digita qualcosa e avvia la ricerca!';

  @override
  String get noDescriptionAvailable =>
      'La trama di questo titolo non è disponibile';

  @override
  String get addToShelf => 'Aggiungi alla libreria';

  @override
  String get orderByAddedDate => 'Ordina per data di aggiunta:';

  @override
  String get ascendingOrder => 'Dal più nuovo al più vecchio';

  @override
  String get descendingOrder => 'Dal più vecchio al più nuovo';

  @override
  String get dateAdded => 'Data di aggiunta';

  @override
  String get startReading => 'Inizio lettura';

  @override
  String get notStartedYet => 'Non ancora iniziata';

  @override
  String get endOfReading => 'Fine lettura';

  @override
  String get inProgress => 'In corso';

  @override
  String get imageError => 'Errore';

  @override
  String get deleteFromShelf => 'Rimuovi dalla libreria';

  @override
  String get alreadyInLibraryFailure =>
      'Questo libro è già presente nella tua libreria.';

  @override
  String get bookNotFoundFailure => 'Libro non trovato nella tua libreria.';

  @override
  String get removingFailure => 'Impossibile rimuovere il libro. Riprova.';

  @override
  String get addingFailure => 'Impossibile aggiungere il libro. Riprova.';

  @override
  String get readingStatusNotStarted => 'Non iniziato';

  @override
  String get readingStatusInProgress => 'In lettura';

  @override
  String get readingStatusFinished => 'Completato';

  @override
  String get emptyFilterResults =>
      'Nessun libro trovato per il filtro selezionato';

  @override
  String get filterDialogTitle => 'Mostra:';

  @override
  String get filterAll => 'Tutti i libri';

  @override
  String get filterNotStarted => 'Letture da iniziare';

  @override
  String get filterInProgress => 'Letture in corso';

  @override
  String get filterFinished => 'Letture completate';

  @override
  String get save => 'Salva';
}
