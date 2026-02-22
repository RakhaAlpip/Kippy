import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/bookmark.dart';
import '../../domain/usecases/get_bookmarks.dart';
import '../../domain/usecases/save_bookmark.dart';
import '../../domain/usecases/remove_bookmark.dart';

part 'bookmark_event.dart';
part 'bookmark_state.dart';

/// BLoC for bookmark (saved posts) functionality.
class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final GetBookmarks _getBookmarks;
  final SaveBookmark _saveBookmark;
  final RemoveBookmark _removeBookmark;

  BookmarkBloc({
    required GetBookmarks getBookmarks,
    required SaveBookmark saveBookmark,
    required RemoveBookmark removeBookmark,
  }) : _getBookmarks = getBookmarks,
       _saveBookmark = saveBookmark,
       _removeBookmark = removeBookmark,
       super(BookmarkInitial()) {
    on<BookmarkFetchRequested>(_onFetch);
    on<BookmarkSaveRequested>(_onSave);
    on<BookmarkRemoveRequested>(_onRemove);
  }

  Future<void> _onFetch(
    BookmarkFetchRequested event,
    Emitter<BookmarkState> emit,
  ) async {
    emit(BookmarkLoading());
    final result = await _getBookmarks();
    result.fold(
      (failure) => emit(BookmarkError(failure.message)),
      (bookmarks) => emit(BookmarkLoaded(bookmarks)),
    );
  }

  Future<void> _onSave(
    BookmarkSaveRequested event,
    Emitter<BookmarkState> emit,
  ) async {
    final result = await _saveBookmark(event.bookmark);
    result.fold(
      (failure) => emit(BookmarkError(failure.message)),
      (_) => add(BookmarkFetchRequested()), // Reload list
    );
  }

  Future<void> _onRemove(
    BookmarkRemoveRequested event,
    Emitter<BookmarkState> emit,
  ) async {
    final result = await _removeBookmark(event.postId);
    result.fold(
      (failure) => emit(BookmarkError(failure.message)),
      (_) => add(BookmarkFetchRequested()), // Reload list
    );
  }
}
