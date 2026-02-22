part of 'bookmark_bloc.dart';

abstract class BookmarkEvent extends Equatable {
  const BookmarkEvent();

  @override
  List<Object?> get props => [];
}

class BookmarkFetchRequested extends BookmarkEvent {}

class BookmarkSaveRequested extends BookmarkEvent {
  final Bookmark bookmark;
  const BookmarkSaveRequested(this.bookmark);

  @override
  List<Object?> get props => [bookmark];
}

class BookmarkRemoveRequested extends BookmarkEvent {
  final String postId;
  const BookmarkRemoveRequested(this.postId);

  @override
  List<Object?> get props => [postId];
}
