import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:books_repository/books_repository.dart';
import 'package:books_api/books_api.dart';
import 'package:shelf_api/shelf_api.dart';

import '../../models/library_filter.dart';

part 'shelf_event.dart';
part 'shelf_state.dart';

/// Manages the state and operations of the user's book shelf collection.
///
/// Handles real-time shelf stream subscriptions, adding or removing books,
/// and applying custom sorting orders.
class ShelfBloc extends Bloc<ShelfEvent, ShelfState> {
  ShelfBloc({
    required BooksRepository booksRepository,
  })  : _booksRepository = booksRepository,
        super(const ShelfState()) {
    on<ShelfSubscriptionRequested>(
        _onSubscriptionRequested,
        transformer: restartable(),
    );
    on<SortShelfOrderChanged>(_onSortShelfOrderChanged);
    on<ShelfFilterChanged>(_onShelfFilterChanged);
    on<AddBook>(_onAddBook);
    on<DeleteSavedBook>(_onDeleteSavedBook);
  }

  final BooksRepository _booksRepository;

  Future<void> _onSubscriptionRequested(
      ShelfSubscriptionRequested event,
      Emitter<ShelfState> emit,
      ) async {
    emit(state.copyWith(status: ShelfStatus.loading));

    await emit.forEach<List<SavedBook>>(
      _booksRepository.getSavedBooks(order: state.orderBy),
      onData: (shelfBooks) => state.copyWith(
        status: ShelfStatus.success,
        shelfBooks: shelfBooks,
      ),
      onError: (_, __) => state.copyWith(
        status: ShelfStatus.failure,
      ),
    );
  }

  void _onSortShelfOrderChanged(
      SortShelfOrderChanged event,
      Emitter<ShelfState> emit,
      ) {
    if (state.orderBy == event.newSortOrder) return;

    emit(state.copyWith(orderBy: event.newSortOrder));
    add(const ShelfSubscriptionRequested());
  }

  void _onShelfFilterChanged(
      ShelfFilterChanged event,
      Emitter<ShelfState> emit,
      ) {
    emit(state.copyWith(filter: event.filter));
  }

  Future<void> _onAddBook(
      AddBook event,
      Emitter<ShelfState> emit,
      ) async {
    try {
      await _booksRepository.addBook(event.newBook);
    } on BookAlreadyInLibraryException catch (_) {
      emit(state.copyWith(status: ShelfStatus.alreadyInLibraryFailure));
    } catch (_) {
      emit(state.copyWith(status: ShelfStatus.addingFailure));
    }
  }

  Future<void> _onDeleteSavedBook(
      DeleteSavedBook event,
      Emitter<ShelfState> emit,
      ) async {
    try {
      await _booksRepository.removeBook(event.savedBookId);
    } on BookNotFoundException catch (_) {
      emit(state.copyWith(status: ShelfStatus.bookNotFoundFailure));
    } catch (_) {
      emit(state.copyWith(status: ShelfStatus.removingFailure));
    }
  }
}