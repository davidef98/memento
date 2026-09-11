import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:memento/functionalities/shelf/bloc/shelf_bloc/shelf_bloc.dart';
import 'package:memento/functionalities/shelf/widgets/empty_shelf.dart';
import 'package:memento/functionalities/shelf/widgets/error_content.dart';
import 'package:memento/functionalities/shelf/widgets/loading_content.dart';
import 'package:memento/theme.dart';
import 'package:memento/utilities/utilities.dart';
import 'package:memento/widgets/scaffold/custom_scaffold.dart';
import 'package:memento/widgets/scaffold/custom_sliver_app_bar.dart';
import 'package:memento/widgets/scroll_bar/custom_scroll_bar.dart';

import '../../../l10n/app_localizations.dart';
import '../../app/language_cubit/language_cubit.dart';
import '../widgets/book_card.dart';

/// The main screen displaying the user's saved book shelf collection.
///
/// Handles first-run language selection prompts via [LanguageCubit], offers app bar
/// actions for language settings, sorting options, and navigation to the search screen.
class ShelfScreen extends StatefulWidget {
  const ShelfScreen({super.key});

  @override
  State<ShelfScreen> createState() => _ShelfScreenState();
}

class _ShelfScreenState extends State<ShelfScreen> {
  /// Controller managing scroll position for [CustomScrollbar] and [CustomScrollView].
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isIOS = context.isIOS;
    final IconData addIconData = isIOS ? CupertinoIcons.add_circled_solid : Icons.add;
    final IconData sortingIcon = CupertinoIcons.arrow_up_arrow_down;
    final IconData filterIcon = Icons.sort;
    final Color iconsColor = AppThemes.secondaryColor;
    final double iconsSize = 22;

    return MultiBlocListener(
      listeners:[
        BlocListener<ShelfBloc, ShelfState>(
            listener: (context, state) {
              final l10n = AppLocalizations.of(context)!;
              final status = state.status;

              final String? message = switch (status) {
                ShelfStatus.bookNotFoundFailure => l10n.bookNotFoundFailure,
                ShelfStatus.removingFailure => l10n.removingFailure,
                _ => null,
              };

              if (message != null) {
                DialogUtilities.showErrorBottomSheet(context, message);
              }
        })
      ],
      child: CustomScaffold(
        customScrollView: CustomScrollbar(
          controller: _scrollController,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              CustomSliverAppBar(
                title: "",
                showBackButton: false,
                actions: [
                  /// Action button to open language selection sheet.
                  IconButton(
                      onPressed: () {
                        DialogUtilities.showLanguageBottomSheet(context);
                        },
                      icon: Icon(
                        Icons.translate,
                        size: iconsSize,
                        color: iconsColor,
                      )
                  ),

                  /// Action button to open shelf sorting dialog.
                  IconButton(
                      onPressed: () {
                        DialogUtilities.showShelfSortingDialog(context);
                        },
                      icon: Icon(
                        sortingIcon,
                        size: iconsSize,
                        color: iconsColor,
                      )
                  ),

                  /// Action button to open shelf filter dialog.
                  IconButton(
                      onPressed: () {
                        DialogUtilities.showShelfFilterDialog(context);
                      },
                      icon: Icon(
                        filterIcon,
                        size: iconsSize,
                        color: iconsColor,
                      )
                  ),

                  /// Action button navigating to the book search screen.
                  IconButton(
                      onPressed: () => GoRouter.of(context).push('/search'),
                      icon: Icon(
                        addIconData,
                        size: iconsSize,
                        color: iconsColor,
                      )
                  )
                ],
              ),
              BlocBuilder<ShelfBloc, ShelfState>(
                  builder: (context, state) {
                    if(state.status.isInitial || state.status.isLoading){
                      return LoadingContent();
                    } else if(state.status.isFailure){
                      return ErrorContent(
                        onPressed:() {
                          context
                              .read<ShelfBloc>()
                              .add(const ShelfSubscriptionRequested());
                          },
                      );
                    } else if(state.status.isSuccess) {
                      final books = state.filteredBooks.toList();
                      /// First case: Empty Shelf
                      if (state.shelfBooks.isEmpty) {
                        return EmptyContent(
                          message: AppLocalizations.of(context)!.emptyShelf,
                        );
                      }
                      ///Second case: Empty Shelf fot the selected filter
                      else if (books.isEmpty) {
                        return EmptyContent(
                          message: AppLocalizations.of(context)!.emptyFilterResults,
                        );
                      }
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final book = books[index];
                            return BookCard(
                              book: book,
                              onTap: () {
                                DialogUtilities.showShelfBookDetail(book: book, context);
                              },
                            );
                          },
                          childCount: books.length,
                        ),
                      );
                    } return EmptyContent(message: '');
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
