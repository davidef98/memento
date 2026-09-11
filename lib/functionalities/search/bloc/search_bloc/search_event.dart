part of 'search_bloc.dart';

/// Base class for all events handled by the [SearchBloc].
sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

/// Event dispatched to request the next page of search results (pagination).
final class LoadMoreBooks extends SearchEvent {}

/// Event dispatched to execute a new book search for the specified query.
final class FetchBooks extends SearchEvent {
  /// The query string entered by the user.
  final String query;

  const FetchBooks(this.query);

  @override
  List<Object> get props => [query];
}

/// Event dispatched to clear the current search results and reset the query.
final class ClearSearch extends SearchEvent {}


/// Event dispatched to pre-fill the search field query without
/// immediately triggering a new search request.
/// Dispatched when selecting a query from the search history
/// to pre-fill the search field.
final class PopulateQuery extends SearchEvent {
  final String query;

  const PopulateQuery(this.query);

  @override
  List<Object> get props => [query];
}

