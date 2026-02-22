part of 'social_bloc.dart';

abstract class SocialEvent extends Equatable {
  const SocialEvent();

  @override
  List<Object?> get props => [];
}

class SocialLikePostRequested extends SocialEvent {
  final String postId;
  const SocialLikePostRequested(this.postId);

  @override
  List<Object?> get props => [postId];
}

class SocialUnlikePostRequested extends SocialEvent {
  final String postId;
  const SocialUnlikePostRequested(this.postId);

  @override
  List<Object?> get props => [postId];
}

class SocialFetchCommentsRequested extends SocialEvent {
  final String postId;
  const SocialFetchCommentsRequested(this.postId);

  @override
  List<Object?> get props => [postId];
}

class SocialAddCommentRequested extends SocialEvent {
  final String postId;
  final String content;
  const SocialAddCommentRequested({
    required this.postId,
    required this.content,
  });

  @override
  List<Object?> get props => [postId, content];
}

class SocialDeleteCommentRequested extends SocialEvent {
  final String postId;
  final String commentId;
  const SocialDeleteCommentRequested({
    required this.postId,
    required this.commentId,
  });

  @override
  List<Object?> get props => [postId, commentId];
}

class SocialFollowUserRequested extends SocialEvent {
  final String userId;
  const SocialFollowUserRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class SocialUnfollowUserRequested extends SocialEvent {
  final String userId;
  const SocialUnfollowUserRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}
