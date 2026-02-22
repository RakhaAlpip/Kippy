part of 'social_bloc.dart';

abstract class SocialState extends Equatable {
  const SocialState();

  @override
  List<Object?> get props => [];
}

class SocialInitial extends SocialState {}

class SocialLoading extends SocialState {}

class SocialCommentsLoaded extends SocialState {
  final List<Comment> comments;

  const SocialCommentsLoaded(this.comments);

  @override
  List<Object?> get props => [comments];
}

class SocialActionSuccess extends SocialState {
  final String message;

  const SocialActionSuccess({this.message = 'Action completed'});

  @override
  List<Object?> get props => [message];
}

class SocialError extends SocialState {
  final String message;

  const SocialError(this.message);

  @override
  List<Object?> get props => [message];
}
