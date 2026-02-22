part of 'bookmark_bloc.dart';

abstract class BookmarkState extends Equatable {
  const BookmarkState();

  @override
  List<Object?> get props => [];
}

class BookmarkInitial extends BookmarkState {}

class BookmarkLoading extends BookmarkState {}

class BookmarkLoaded extends BookmarkState {
  final List<Bookmark> bookmarks;

  const BookmarkLoaded(this.bookmarks);

  @override
  List<Object?> get props => [bookmarks];
}

class BookmarkActionSuccess extends BookmarkState {
  final String message;

  const BookmarkActionSuccess({this.message = 'Done!'});

  @override
  List<Object?> get props => [message];
}

class BookmarkError extends BookmarkState {
  final String message;

  const BookmarkError(this.message);

  @override
  List<Object?> get props => [message];
}
