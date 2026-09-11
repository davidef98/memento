import 'package:books_repository/books_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memento/functionalities/search/bloc/search_bloc/search_bloc.dart';
import 'package:memento/functionalities/shelf/widgets/empty_shelf.dart';
import 'package:memento/functionalities/shelf/widgets/error_content.dart';
import 'package:memento/functionalities/shelf/widgets/loading_content.dart';
import 'package:memento/l10n/app_localizations.dart';
import 'package:memento/utilities/utilities.dart';
import 'package:memento/widgets/scaffold/custom_scaffold.dart';
import 'package:memento/widgets/scaffold/custom_sliver_app_bar.dart';
import 'package:memento/widgets/scroll_bar/custom_scroll_bar.dart';

import '../../../widgets/loading_indicators/bottom_list_loader.dart';
import '../../shelf/bloc/shelf_bloc/shelf_bloc.dart';
import '../widgets/book_search_bar.dart';
import '../widgets/search_result_book_card.dart';

/// The main search screen that provides [SearchBloc] to its view tree.
///
/// Serves as the entry point for searching books, displaying results,
/// loading indicators, or error states.
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchBloc(
        booksRepository: context.read<BooksRepository>(),
      ),
      child: SearchScreenContent(),
    );
  }
}

/// The internal content implementation for [SearchScreen].
///
/// Handles text field controllers, infinite scroll pagination, and
/// UI state transitions based on [SearchBloc] states.
class SearchScreenContent extends StatefulWidget {
  const SearchScreenContent({super.key});

  @override
  State<SearchScreenContent> createState() => SearchScreenContentState();
}

class SearchScreenContentState extends State<SearchScreenContent> {
  late TextEditingController _searchController;
  late FocusNode _focusNode;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _focusNode = FocusNode();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  /// Fills the search input field with [query] and requests focus.
  /// Executed post-frame to ensure the UI has completed its rebuild.
  /// It was designed for selecting a query from the search history.
  void _populateQuery(String query) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchController.text = query;
      _focusNode.requestFocus();
    });
  }

  /// Detects when the scroll position reaches the bottom and triggers pagination.
  void _onScroll() {
    if (_scrollController.isAtBottom()) {
      context.read<SearchBloc>().add(LoadMoreBooks());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShelfBloc, ShelfState>(
        listener: (context, state) {
          final l10n = AppLocalizations.of(context)!;
          final status = state.status;

          final String? message = switch (status) {
            ShelfStatus.alreadyInLibraryFailure => l10n.alreadyInLibraryFailure,
            ShelfStatus.addingFailure => l10n.addingFailure,
            _ => null,
          };

          if (message != null) {
            DialogUtilities.showErrorBottomSheet(context, message);
          }
        },
      child: CustomScaffold(
            customScrollView: CustomScrollbar(
              controller: _scrollController,
              child: BlocListener<SearchBloc, SearchState>(
                listener: (context, state) {
                  if(state.status.isQueryPopulated){
                    _populateQuery(state.query);
                  }
                },
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    CustomSliverAppBar(
                      showBackButton: false,
                      pinned: true,
                      floating: false,
                      title: '',
                      widget: Padding(
                        padding: EdgeInsetsGeometry.only(right: 8),
                        child: BookSearchBar(
                            innerContext: context,
                            controller: _searchController,
                            focusNode: _focusNode
                        ),
                      ),
                      preferredSize: const Size.fromHeight(0.0),
                    ),
                    BlocBuilder<SearchBloc, SearchState>(
                        builder: (context, state) {
                          if (state.status.isInitial){
                            return EmptyContent(
                                message: AppLocalizations.of(context)!.startSearching
                            );
                          }else if(state.status.isLoading){
                            return LoadingContent();
                          } else if(state.status.isFailure){
                            return ErrorContent(
                                onPressed: () {
                                  final bloc = context.read<SearchBloc>();
                                  final query = bloc.state.query;
                                  bloc.add(FetchBooks(query));
                                });
                          } else if(state.status.isSuccess && state.books.isEmpty){
                            return EmptyContent(
                                message: AppLocalizations.of(context)!.noSearchResults
                            );
                          }
                          final books = state.books;
                          final hasReachedMax = state.hasReachedMax;

                          return SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  childCount: hasReachedMax ? books.length : books.length + 1,
                                  (context, index){
                                    if (index >= books.length) {
                                      return const BottomListLoader();
                                    }
                                    final book = books[index];
                                    return SearchResultBookCard(
                                      book: book,
                                      onTap: () {
                                        DialogUtilities.showBookDetailDialog(context, book: book);
                                      },
                                    );
                                  }
                              )
                          );
                        }
                    )
                  ],
                ),
              ),
            )
      ),
    );
  }
}

