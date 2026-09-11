part of 'search_bloc.dart';

enum SearchStatus { initial, loading, success, empty, queryPopulated, failure }

/// Extension methods for [SearchStatus] to simplify status evaluation
/// and improve code readability in UI and BLoC logic.
extension SearchStatusX on SearchStatus {
  bool get isInitial => this == SearchStatus.initial;
  bool get isLoading => this == SearchStatus.loading;
  bool get isEmpty=> this == SearchStatus.empty;
  bool get isQueryPopulated => this == SearchStatus.queryPopulated;
  bool get isSuccess => this == SearchStatus.success;
  bool get isFailure => this == SearchStatus.failure;
}

final class SearchState extends Equatable {
  const SearchState({
    this.status = SearchStatus.initial,
    this.books = const <BookGeneric>[],
    this.hasReachedMax = false,
    this.query = '',
  });

  final SearchStatus status;
  final List<BookGeneric> books;
  final bool hasReachedMax;
  final String query;

  SearchState copyWith({
    SearchStatus? status,
    List<BookGeneric>? books,
    bool? hasReachedMax,
    String? query,
  }) {
    return SearchState(
      status: status ?? this.status,
      books: books ?? this.books,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      query: query ?? this.query,
    );
  }

  @override
  String toString() {
    return
      '''SearchState {
        status: $status,
        hasReachedMax: $hasReachedMax,
        books: ${books.length},
        query: $query,
      }''';
  }

  @override
  List<Object> get props => [
    status,
    books,
    query,
    hasReachedMax,
  ];
}