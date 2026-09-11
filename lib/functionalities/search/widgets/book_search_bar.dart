import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:form_inputs/forms_input.dart';
import 'package:memento/l10n/app_localizations.dart';
//import 'package:memento/functionalities/app/bloc/history_bloc/history_bloc.dart';


import '../../../widgets/custom_search_bar/custom_search_bar.dart';
import '../bloc/search_bloc/search_bloc.dart';

/// A specialized search bar widget for book queries.
///
/// Wraps a [CustomSearchBar] to handle user input validation, clearing the current search,
/// and dispatching search requests to the [SearchBloc].
class BookSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final BuildContext innerContext;

  const BookSearchBar({
    required this.controller,
    required this.focusNode,
    required this.innerContext,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomSearchBar(
      controller: controller,
      focusNode: focusNode,
      innerContext: innerContext,

      /// Required validation logic for search queries.
      /// This is a demo so this function doesn't do a significant work.
      validator: (query) {
        if (query.trim().isEmpty) return AppLocalizations.of(context)!.noSearchResults;
        return null;
      },
      /// Handles clearing the text input and resetting the [SearchBloc] state.
      onClear: () {
        controller.clear();
        context.read<SearchBloc>().add(ClearSearch());
      },
      /// Triggers a new book search when the user submits a query.
      onSearch: (query) async {
        context.read<SearchBloc>().add(FetchBooks(query));
        //context.read<HistoryBloc>().add(HistoryQueryAdded(query));
      },
      placeholderContent: AppLocalizations.of(context)!.searchPlaceHolder,
    );
  }
}
