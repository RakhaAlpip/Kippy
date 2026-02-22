part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Post> posts;
  final List<Story> stories;
  final bool hasReachedMax;

  const HomeLoaded({
    required this.posts,
    required this.stories,
    this.hasReachedMax = false,
  });

  HomeLoaded copyWith({
    List<Post>? posts,
    List<Story>? stories,
    bool? hasReachedMax,
  }) {
    return HomeLoaded(
      posts: posts ?? this.posts,
      stories: stories ?? this.stories,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [posts, stories, hasReachedMax];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
