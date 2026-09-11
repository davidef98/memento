import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memento/functionalities/shelf/bloc/shelf_bloc/shelf_bloc.dart';
import 'package:memento/functionalities/shelf/widgets/sorting_row_buttons.dart';
import 'package:memento/l10n/app_localizations.dart';
import 'package:memento/widgets/dialogs/dialog_basics/dialog_structure.dart';
import 'package:shelf_api/shelf_api.dart';

/// A dialog that allows users to change the sorting order of their shelf collection.
///
/// Listens to [ShelfBloc] state changes and dispatches [SortShelfOrderChanged]
/// events when a sorting option is selected.
class ShelfSortDialog extends StatelessWidget {
  const ShelfSortDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return DialogStructure(
      title: AppLocalizations.of(context)!.orderByAddedDate,
      bodyContent: [
        BlocBuilder<ShelfBloc, ShelfState>(
            builder: (context, state){
              return SortingRowButtons(
                onAsc: (){
                  context.read<ShelfBloc>().add(SortShelfOrderChanged(LibrarySortOrder.savedAtDescending));
                  Navigator.pop(context);
                },
                onDesc: (){
                  context.read<ShelfBloc>().add(SortShelfOrderChanged(LibrarySortOrder.savedAtAscending));
                  Navigator.pop(context);
                },
                highlightAsc: state.orderBy == LibrarySortOrder.savedAtDescending,
                highlightDesc: state.orderBy == LibrarySortOrder.savedAtAscending,
              );
            }
        )
      ],
    );
  }
}

