import 'package:books_api/books_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:books_repository/books_repository.dart';

part 'book_detail_event.dart';
part 'book_detail_state.dart';

class BookDetailBloc extends Bloc<BookDetailEvent, BookDetailState> {
  final BooksRepository _booksRepository;

  BookDetailBloc({required BooksRepository booksRepository}) : _booksRepository = booksRepository,
        super(const BookDetailState()) {
    on<FetchBook>(
      _onFetchBook,
    );
  }

  Future<void> _onFetchBook(
      FetchBook event,
      Emitter<BookDetailState> emit,
      ) async {
    emit(state.copyWith(status: BookStatus.loading));

    try {
      final book = await _booksRepository.fetchBookDetail(event.bookId);
      emit(state.copyWith(status: BookStatus.success, book: book));
    } catch (e) {
      emit(state.copyWith(status: BookStatus.failure));
    }
  }
}

