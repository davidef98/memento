import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In it, this message translates to:
  /// **'Memento'**
  String get appTitle;

  /// No description provided for @shelfTitle.
  ///
  /// In it, this message translates to:
  /// **'La tua Libreria'**
  String get shelfTitle;

  /// No description provided for @loadingContent.
  ///
  /// In it, this message translates to:
  /// **'Caricamento in corso...'**
  String get loadingContent;

  /// No description provided for @emptyShelf.
  ///
  /// In it, this message translates to:
  /// **'Al momento la tua biblioteca è vuota. \nAggiungi dei titoli!'**
  String get emptyShelf;

  /// No description provided for @errorClickHere.
  ///
  /// In it, this message translates to:
  /// **'Si è verificato un errore, clicca qui per riprovare'**
  String get errorClickHere;

  /// No description provided for @searchPlaceHolder.
  ///
  /// In it, this message translates to:
  /// **'Cerca...'**
  String get searchPlaceHolder;

  /// No description provided for @noSearchResults.
  ///
  /// In it, this message translates to:
  /// **'La ricerca non ha restituito alcun risulta. \nCerca qualcosa di diverso'**
  String get noSearchResults;

  /// No description provided for @errorModalTitle.
  ///
  /// In it, this message translates to:
  /// **'Errore'**
  String get errorModalTitle;

  /// No description provided for @italian.
  ///
  /// In it, this message translates to:
  /// **'Italiano'**
  String get italian;

  /// No description provided for @english.
  ///
  /// In it, this message translates to:
  /// **'Inglese'**
  String get english;

  /// No description provided for @langAlertTitle.
  ///
  /// In it, this message translates to:
  /// **'Seleziona la tua lingua:'**
  String get langAlertTitle;

  /// No description provided for @startSearching.
  ///
  /// In it, this message translates to:
  /// **'Digita qualcosa e avvia la ricerca!'**
  String get startSearching;

  /// No description provided for @noDescriptionAvailable.
  ///
  /// In it, this message translates to:
  /// **'La trama di questo titolo non è disponibile'**
  String get noDescriptionAvailable;

  /// No description provided for @addToShelf.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi alla libreria'**
  String get addToShelf;

  /// No description provided for @orderByAddedDate.
  ///
  /// In it, this message translates to:
  /// **'Ordina per data di aggiunta:'**
  String get orderByAddedDate;

  /// No description provided for @ascendingOrder.
  ///
  /// In it, this message translates to:
  /// **'Dal più nuovo al più vecchio'**
  String get ascendingOrder;

  /// No description provided for @descendingOrder.
  ///
  /// In it, this message translates to:
  /// **'Dal più vecchio al più nuovo'**
  String get descendingOrder;

  /// No description provided for @dateAdded.
  ///
  /// In it, this message translates to:
  /// **'Data di aggiunta'**
  String get dateAdded;

  /// No description provided for @startReading.
  ///
  /// In it, this message translates to:
  /// **'Inizio lettura'**
  String get startReading;

  /// No description provided for @notStartedYet.
  ///
  /// In it, this message translates to:
  /// **'Non ancora iniziata'**
  String get notStartedYet;

  /// No description provided for @endOfReading.
  ///
  /// In it, this message translates to:
  /// **'Fine lettura'**
  String get endOfReading;

  /// No description provided for @inProgress.
  ///
  /// In it, this message translates to:
  /// **'In corso'**
  String get inProgress;

  /// No description provided for @imageError.
  ///
  /// In it, this message translates to:
  /// **'Errore'**
  String get imageError;

  /// No description provided for @deleteFromShelf.
  ///
  /// In it, this message translates to:
  /// **'Rimuovi dalla libreria'**
  String get deleteFromShelf;

  /// No description provided for @alreadyInLibraryFailure.
  ///
  /// In it, this message translates to:
  /// **'Questo libro è già presente nella tua libreria.'**
  String get alreadyInLibraryFailure;

  /// No description provided for @bookNotFoundFailure.
  ///
  /// In it, this message translates to:
  /// **'Libro non trovato nella tua libreria.'**
  String get bookNotFoundFailure;

  /// No description provided for @removingFailure.
  ///
  /// In it, this message translates to:
  /// **'Impossibile rimuovere il libro. Riprova.'**
  String get removingFailure;

  /// No description provided for @addingFailure.
  ///
  /// In it, this message translates to:
  /// **'Impossibile aggiungere il libro. Riprova.'**
  String get addingFailure;

  /// No description provided for @readingStatusNotStarted.
  ///
  /// In it, this message translates to:
  /// **'Non iniziato'**
  String get readingStatusNotStarted;

  /// No description provided for @readingStatusInProgress.
  ///
  /// In it, this message translates to:
  /// **'In lettura'**
  String get readingStatusInProgress;

  /// No description provided for @readingStatusFinished.
  ///
  /// In it, this message translates to:
  /// **'Completato'**
  String get readingStatusFinished;

  /// No description provided for @emptyFilterResults.
  ///
  /// In it, this message translates to:
  /// **'Nessun libro trovato per il filtro selezionato'**
  String get emptyFilterResults;

  /// No description provided for @filterDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Mostra:'**
  String get filterDialogTitle;

  /// No description provided for @filterAll.
  ///
  /// In it, this message translates to:
  /// **'Tutti i libri'**
  String get filterAll;

  /// No description provided for @filterNotStarted.
  ///
  /// In it, this message translates to:
  /// **'Letture da iniziare'**
  String get filterNotStarted;

  /// No description provided for @filterInProgress.
  ///
  /// In it, this message translates to:
  /// **'Letture in corso'**
  String get filterInProgress;

  /// No description provided for @filterFinished.
  ///
  /// In it, this message translates to:
  /// **'Letture completate'**
  String get filterFinished;

  /// No description provided for @save.
  ///
  /// In it, this message translates to:
  /// **'Salva'**
  String get save;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
