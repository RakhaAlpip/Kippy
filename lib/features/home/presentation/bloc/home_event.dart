part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Load the initial feed and stories.
class HomeFetchRequested extends HomeEvent {}

/// Load more posts (pagination).
class HomeLoadMoreRequested extends HomeEvent {}

/// Refresh the feed.
class HomeRefreshRequested extends HomeEvent {}
