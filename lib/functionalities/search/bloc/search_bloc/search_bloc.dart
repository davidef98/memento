import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';

import 'package:books_api/books_api.dart';
import 'package:books_repository/books_repository.dart';

import '../../../../utilities/throttle_duration.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final BooksRepository _booksRepository;

  SearchBloc({required BooksRepository booksRepository})
      : _booksRepository = booksRepository,
        super(const SearchState()) {
    on<LoadMoreBooks>(
      _onLoadMoreBooks,
      transformer: throttleDroppable(throttleDuration),
    );
    on<FetchBooks>(
      _onFetchBooks,
      transformer: restartable(),
    );
    on<PopulateQuery>(
      _onPopulateQuery,
      transformer: restartable(),
    );
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onLoadMoreBooks(
      LoadMoreBooks event,
      Emitter<SearchState> emit,
      ) async {
    if (state.status != SearchStatus.success || state.hasReachedMax) return;

    try {
      final results = await _booksRepository.searchBooks(
        query: state.query,
        offset: state.books.length,
      );

      if (results.docs.isEmpty) {
        emit(state.copyWith(hasReachedMax: true));
        return;
      }

      final allBooks = [...state.books, ...results.docs];

      emit(
        state.copyWith(
          status: SearchStatus.success,
          books: allBooks,
          query: state.query,
          hasReachedMax: allBooks.length >= results.numFound,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: SearchStatus.failure));
    }
  }

  Future<void> _onFetchBooks(
      FetchBooks event,
      Emitter<SearchState> emit,
      ) async {

    emit(state.copyWith(status: SearchStatus.loading));

    try {
      final results = await _booksRepository.searchBooks(
          query: event.query,
      );

      emit(results.docs.isEmpty
          ? state.copyWith(
        status: SearchStatus.empty,
        books: [],
        query: event.query,
        hasReachedMax: false,
      )
          : state.copyWith(
        status: SearchStatus.success,
        books: results.docs,
        query: event.query,
        hasReachedMax: results.docs.length >= results.numFound,
      ));
    } catch (error) {
      emit(state.copyWith(status: SearchStatus.failure));
    }
  }


  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    emit(state.copyWith(
      status: SearchStatus.initial,
      books: const <BookGeneric>[],
      hasReachedMax: false,
      query : '',
    )
    );
  }

  void _onPopulateQuery(PopulateQuery event, Emitter<SearchState> emit) {
    emit(
        state.copyWith(
          status: SearchStatus.queryPopulated,
          books: const <BookGeneric>[],
          hasReachedMax: false,
          query : event.query,
        )
    );
  }
}
