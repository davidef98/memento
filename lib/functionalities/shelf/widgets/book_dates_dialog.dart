import 'package:books_repository/books_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:memento/functionalities/shelf/models/saved_book_extension.dart';
import 'package:memento/theme.dart';
import 'package:shelf_api/shelf_api.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../utilities/utilities.dart';
import '../../../widgets/buttons/custom_elevated_button.dart';
import '../../../widgets/dialogs/dialog_basics/dialog_structure.dart';
import '../bloc/book_dates_cubit/book_dates_cubit.dart';
import '../bloc/shelf_bloc/shelf_bloc.dart';

/// A dialog that allows users to view and update reading dates (start/end)
/// or delete a saved book from their shelf.
///
/// Provides visual feedback on reading states (e.g., not started, in progress, completed)
/// and triggers [BookDatesCubit] and [ShelfBloc] operations.
class BookDatesDialog extends StatelessWidget {
  final SavedBook book;

  const BookDatesDialog({
    required this.book,
    super.key,
  });

  /// Formats a [DateTime] instance into a localized full date string (e.g., "MMMM d, yyyy").
  /// Returns '-' if the date is null.
  String _formatDate(BuildContext context, DateTime? date) {
    if (date == null) return '-';
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMMd(locale).format(date);
  }

  /// Determines the localized subtitle text for the reading end date field
  /// using the [SavedBookX] extension status.
  String _getEndDateSubtitle(BuildContext context, SavedBook book) {
    final l10n = AppLocalizations.of(context)!;

    return switch (book.readingStatus) {
      ReadingStatus.finished => _formatDate(context, book.endDate),
      ReadingStatus.inProgress => l10n.readingStatusInProgress,
      ReadingStatus.notStarted => l10n.readingStatusNotStarted,
    };
  }

  /// Displays a date picker for selecting reading dates.
  Future<void> _selectDate(
      BuildContext context, {
        required DateTime? initialDate,
        required ValueChanged<DateTime?> onDateSelected,
      }) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      onDateSelected(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool isIOS = context.isIOS;
    final IconData editIconData = isIOS ? CupertinoIcons.pen : Icons.mode_edit_outline_outlined;
    final IconData addedIconData = isIOS ? CupertinoIcons.bookmark_solid : Icons.bookmark_add_outlined;
    final IconData startIconData = isIOS ? CupertinoIcons.play_circle_fill : Icons.play_circle_fill;
    final IconData inProgressIconData = isIOS ? CupertinoIcons.book : Icons.menu_book;
    final IconData endIconData = isIOS ? CupertinoIcons.checkmark_alt_circle_fill : Icons.check_circle;
    final TextStyle titleStyle = UnifiedTextStyles.bodyText16.copyWith(
      fontWeight: FontWeight.bold,
    );
    final TextStyle subtitleStyle = UnifiedTextStyles.bodyText15.copyWith(
      color: Theme.of(context).colorScheme.outline,
    );

    return BlocProvider(
      create: (context) => BookDatesCubit(
        book: book,
        booksRepository: context.read<BooksRepository>(),
      ),
      child: BlocBuilder<BookDatesCubit, BookDatesState>(
        builder: (context, state) {
          final currentBook = state.book;
          final isFinished = currentBook.readingStatus == ReadingStatus.finished;
          final inProgress = currentBook.readingStatus == ReadingStatus.inProgress;

          return DialogStructure(
            title: currentBook.title,
            bodyContent: [
              /// Date added to shelf (read-only)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(addedIconData),
                title: Text(l10n.dateAdded, style: titleStyle),
                subtitle: Text(
                  _formatDate(context, currentBook.savedAt),
                  style: subtitleStyle,
                ),
              ),

              const Divider(height: 1),

              /// Start reading date picker tile
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                    startIconData,
                ),
                title: Text(l10n.startReading, style: titleStyle),
                subtitle: Text(
                  currentBook.startDate != null
                      ? _formatDate(context, currentBook.startDate)
                      : l10n.notStartedYet,
                  style: subtitleStyle,
                ),
                trailing: Icon(
                    editIconData,
                ),
                onTap: () {
                  _selectDate(
                    context,
                    initialDate: currentBook.startDate,
                    onDateSelected: (newDate) {
                      context.read<BookDatesCubit>().updateStartDate(newDate);
                    },
                  );
                },
              ),

              const Divider(height: 1),

              /// End of reading date picker tile
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  isFinished ? endIconData : inProgressIconData,
                  color: isFinished
                      ? AppThemes.accentColor2
                      : (inProgress ? AppThemes.accentColor3 : null),
                ),
                title: Text(l10n.endOfReading, style: titleStyle),
                subtitle: Text(
                  _getEndDateSubtitle(context, currentBook),
                  style: subtitleStyle,
                ),
                trailing: Icon(editIconData),
                onTap: () {
                  _selectDate(
                    context,
                    initialDate: currentBook.endDate,
                    onDateSelected: (newDate) {
                      context.read<BookDatesCubit>().updateEndDate(newDate);
                    },
                  );
                },
              ),
              const SizedBox(height: 28),

              /// Close modal action button
              CustomElevatedButton(
                message: AppLocalizations.of(context)!.save,
                function: () {
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 8),

              /// Delete book action button
              CustomElevatedButton(
                message: AppLocalizations.of(context)!.deleteFromShelf,
                backgroundColor: AppThemes.accentColor1,
                borderColor: AppThemes.accentColor1,
                function: () {
                  context
                      .read<ShelfBloc>()
                      .add(DeleteSavedBook(book.id));
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      ),
    );
  }
}