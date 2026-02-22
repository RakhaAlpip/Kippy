import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/comment.dart';
import '../../domain/usecases/like_post.dart';
import '../../domain/usecases/add_comment.dart';
import '../../domain/usecases/delete_comment.dart';
import '../../domain/usecases/follow_user.dart';
import '../../domain/repositories/social_repository.dart';

part 'social_event.dart';
part 'social_state.dart';

/// BLoC for social interactions (likes, comments, follows).
class SocialBloc extends Bloc<SocialEvent, SocialState> {
  final LikePost _likePost;
  final AddComment _addComment;
  final DeleteComment _deleteComment;
  final FollowUser _followUser;
  final SocialRepository _repository;

  SocialBloc({
    required LikePost likePost,
    required AddComment addComment,
    required DeleteComment deleteComment,
    required FollowUser followUser,
    required SocialRepository repository,
  }) : _likePost = likePost,
       _addComment = addComment,
       _deleteComment = deleteComment,
       _followUser = followUser,
       _repository = repository,
       super(SocialInitial()) {
    on<SocialLikePostRequested>(_onLikePost);
    on<SocialUnlikePostRequested>(_onUnlikePost);
    on<SocialFetchCommentsRequested>(_onFetchComments);
    on<SocialAddCommentRequested>(_onAddComment);
    on<SocialDeleteCommentRequested>(_onDeleteComment);
    on<SocialFollowUserRequested>(_onFollowUser);
    on<SocialUnfollowUserRequested>(_onUnfollowUser);
  }

  Future<void> _onLikePost(
    SocialLikePostRequested event,
    Emitter<SocialState> emit,
  ) async {
    final result = await _likePost(event.postId);
    result.fold(
      (f) => emit(SocialError(f.message)),
      (_) => emit(const SocialActionSuccess(message: 'Post liked!')),
    );
  }

  Future<void> _onUnlikePost(
    SocialUnlikePostRequested event,
    Emitter<SocialState> emit,
  ) async {
    final result = await _repository.unlikePost(event.postId);
    result.fold(
      (f) => emit(SocialError(f.message)),
      (_) => emit(const SocialActionSuccess(message: 'Post unliked')),
    );
  }

  Future<void> _onFetchComments(
    SocialFetchCommentsRequested event,
    Emitter<SocialState> emit,
  ) async {
    emit(SocialLoading());
    final result = await _repository.getComments(event.postId);
    result.fold(
      (f) => emit(SocialError(f.message)),
      (comments) => emit(SocialCommentsLoaded(comments)),
    );
  }

  Future<void> _onAddComment(
    SocialAddCommentRequested event,
    Emitter<SocialState> emit,
  ) async {
    final result = await _addComment(
      postId: event.postId,
      content: event.content,
    );
    result.fold((f) => emit(SocialError(f.message)), (comment) {
      if (state is SocialCommentsLoaded) {
        final current = (state as SocialCommentsLoaded).comments;
        emit(SocialCommentsLoaded([...current, comment]));
      }
    });
  }

  Future<void> _onDeleteComment(
    SocialDeleteCommentRequested event,
    Emitter<SocialState> emit,
  ) async {
    final result = await _deleteComment(
      postId: event.postId,
      commentId: event.commentId,
    );
    result.fold((f) => emit(SocialError(f.message)), (_) {
      if (state is SocialCommentsLoaded) {
        final current = (state as SocialCommentsLoaded).comments;
        emit(
          SocialCommentsLoaded(
            current.where((c) => c.id != event.commentId).toList(),
          ),
        );
      }
    });
  }

  Future<void> _onFollowUser(
    SocialFollowUserRequested event,
    Emitter<SocialState> emit,
  ) async {
    final result = await _followUser(event.userId);
    result.fold(
      (f) => emit(SocialError(f.message)),
      (_) => emit(const SocialActionSuccess(message: 'User followed!')),
    );
  }

  Future<void> _onUnfollowUser(
    SocialUnfollowUserRequested event,
    Emitter<SocialState> emit,
  ) async {
    final result = await _repository.unfollowUser(event.userId);
    result.fold(
      (f) => emit(SocialError(f.message)),
      (_) => emit(const SocialActionSuccess(message: 'User unfollowed')),
    );
  }
}
