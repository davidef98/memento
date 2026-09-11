import 'package:books_api/books_api.dart';
import 'package:books_repository/books_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../theme.dart';
import '../../../../widgets/dialogs/dialog_basics/dialog_structure.dart';
import '../../../utilities/utilities.dart';
import '../../../widgets/buttons/custom_elevated_button.dart';
import '../../../widgets/loading_indicators/custom_loading_indicator.dart';
import '../../shelf/bloc/shelf_bloc/shelf_bloc.dart';
import '../bloc/book_detail_bloc/book_detail_bloc.dart';

/// A dialog that displays detailed information about a selected book.
///
/// It initializes a [BookDetailBloc] to fetch full book details using the provided
/// [bookGeneric]'s key and allows the user to save the book to their library.
class BookDetailDialog extends StatelessWidget {
  /// The generic book data containing initial information such as title and key.
  final BookGeneric bookGeneric;

  const BookDetailDialog({
    required this.bookGeneric,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookDetailBloc(
        booksRepository: context.read<BooksRepository>(),
      )..add(FetchBook(bookGeneric.key)),
      child: DialogStructure(
        title: bookGeneric.title,
        bodyContent: [
          _buildContent(context, bookGeneric),
        ],
      ),
    );
  }

  /// Builds the dialog content body based on the current state of [BookDetailBloc].
  Widget _buildContent(BuildContext context, BookGeneric bookGeneric) {
    final TextStyle loadingAndErrorTextStyle = UnifiedTextStyles.bodyText16;
    final bool isIOS = context.isIOS;
    final IconData retryIcon = isIOS ? CupertinoIcons.arrow_clockwise : Icons.change_circle_outlined;

    return BlocBuilder<BookDetailBloc, BookDetailState>(
      builder: (context, state) {
        if (state.status.isSuccess) {
          final book = state.book;

          return SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  /// Wraps the book description in a [SingleChildScrollView]
                  /// to prevent [RenderFlex] overflow errors when displaying
                  /// unusually long text descriptions.
                  child: SingleChildScrollView(
                    child: Text(
                      (book.description != null && book.description!.isNotEmpty)
                          ? book.description!
                          : AppLocalizations.of(context)!.noDescriptionAvailable,
                      style: UnifiedTextStyles.bodyText15,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                CustomElevatedButton(
                  message: AppLocalizations.of(context)!.addToShelf,
                  function: () {
                    context.read<ShelfBloc>().add(
                      AddBook(bookGeneric),
                    );
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        } else if (state.status.isLoading) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(child: CustomLoadingIndicator()),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  AppLocalizations.of(context)!.loadingContent,
                  style: loadingAndErrorTextStyle,
                ),
              ),
            ],
          );
        } else {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              IconButton(
                  onPressed: () {
                    context.read<BookDetailBloc>().add(FetchBook(bookGeneric.key));
                  },
                  icon: Icon(
                    retryIcon,
                    size: 28,
                    color: AppThemes.secondaryColor,
                  )
              ),
              const SizedBox(height: 8,),
              Text(
                AppLocalizations.of(context)!.errorClickHere,
                style: UnifiedTextStyles.bodyText16,
              ),
            ],
          );
        }
      },
    );
  }
}