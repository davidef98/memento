import 'package:books_api/books_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memento/functionalities/shelf/bloc/shelf_bloc/shelf_bloc.dart';
import 'package:memento/functionalities/shelf/widgets/book_dates_dialog.dart';
import 'package:memento/functionalities/shelf/widgets/shelf_sort_dialog.dart';
import 'package:shelf_api/shelf_api.dart';

import '../../functionalities/search/widgets/book_detail_dialog.dart';
import '../../functionalities/shelf/widgets/shelf_filter_dialog.dart';
import '../../widgets/dialogs/wrappers/wrappers.dart';
import 'dialog_config.dart';

/// Centralized helper for launching the app's modal bottom sheets.
///
/// Keeping all `showModalBottomSheet` calls behind this single class means
/// every dialog in the app shares the same shape, background color, and
/// scroll/navigator behavior (configured in [DialogConfig]), and that
/// behavior only needs to change in one place if the design changes.
class DialogUtilities {
  /// Prevents instantiation — this class only exposes static helpers.
  DialogUtilities._();

  /// Shared implementation behind every dialog below.
  ///
  /// Centralizing the [showModalBottomSheet] call avoids repeating the same
  /// five [DialogConfig] parameters in every method, and returns a
  /// `Future<T?>` so callers can `await` a result from the sheet
  /// (e.g. a value picked in a selection dialog) when needed.
  static Future<T?> _showBottomSheet<T>({
    required BuildContext context,
    required WidgetBuilder builder,
  }) {
    return showModalBottomSheet<T>(
      shape: DialogConfig.shape,
      backgroundColor: DialogConfig.backgroundColor(context),
      context: context,
      isScrollControlled: DialogConfig.isScrollControlled,
      useRootNavigator: DialogConfig.useRootNavigator,
      builder: builder,
    );
  }

  /// Shows the language selection bottom sheet.
  ///
  /// Used wherever the user needs to change the app's display language
  /// (e.g. from a settings screen).
  static void showLanguageBottomSheet(BuildContext context) {
    _showBottomSheet(
      context: context,
      builder: (_) => const LanguageDialog(),
    );
  }

  /// Shows a generic error bottom sheet displaying [errorMessage].
  static void showErrorBottomSheet(BuildContext context, String errorMessage) {
    _showBottomSheet(
      context: context,
      builder: (_) => GenericErrorDialog(errorMessage: errorMessage),
    );
  }

  /// Shows the book details bottom sheet for a [book] coming from search
  /// results (i.e. not yet saved to the user's shelf).
  ///
  /// Lets the user preview a book's info and, from there, add it to their
  /// shelf.
  static void showBookDetailDialog(
      BuildContext context, {
        required BookGeneric book,
      }) {
    _showBottomSheet(
      context: context,
      builder: (_) => BookDetailDialog(bookGeneric: book),
    );
  }

  /// Shows the reading-dates detail bottom sheet for a [book] already saved
  /// on the user's shelf.
  ///
  /// Lets the user view or edit when they started/finished reading the book,
  /// and delete it from the shelf.
  static void showShelfBookDetail(
      BuildContext context, {
        required SavedBook book,
      }) {
    _showBottomSheet(
      context: context,
      builder: (_) => BookDatesDialog(book: book),
    );
  }

  /// Shows the shelf sorting bottom sheet.
  ///
  /// Reads the existing [ShelfBloc] from [parentContext] and re-provides it
  /// to the sheet via [BlocProvider.value], so the sorting UI can dispatch
  /// events to the same bloc instance that manages the shelf list — instead
  /// of accidentally creating a new, disconnected bloc inside the sheet.
  static void showShelfSortingDialog(BuildContext parentContext) {
    final shelfBloc = parentContext.read<ShelfBloc>();
    _showBottomSheet(
      context: parentContext,
      builder: (_) => BlocProvider.value(
        value: shelfBloc,
        child: const ShelfSortDialog(),
      ),
    );
  }

  static void showShelfFilterDialog(BuildContext parentContext) {
    final shelfBloc = parentContext.read<ShelfBloc>();
    _showBottomSheet(
      context: parentContext,
      builder: (_) => BlocProvider.value(
        value: shelfBloc,
        child: const ShelfFilterDialog(),
      ),
    );
  }
}