import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/post.dart';
import '../../domain/entities/story.dart';
import '../../domain/usecases/get_feed_posts.dart';
import '../../domain/usecases/get_stories.dart';

part 'home_event.dart';
part 'home_state.dart';

/// BLoC handling the home feed state.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetFeedPosts _getFeedPosts;
  final GetStories _getStories;
  int _currentPage = 1;

  HomeBloc({required GetFeedPosts getFeedPosts, required GetStories getStories})
    : _getFeedPosts = getFeedPosts,
      _getStories = getStories,
      super(HomeInitial()) {
    on<HomeFetchRequested>(_onFetchRequested);
    on<HomeLoadMoreRequested>(_onLoadMore);
    on<HomeRefreshRequested>(_onRefresh);
  }

  Future<void> _onFetchRequested(
    HomeFetchRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    _currentPage = 1;

    final postsResult = await _getFeedPosts(page: _currentPage);
    final storiesResult = await _getStories();

    // TODO: Handle combined results
    postsResult.fold((failure) => emit(HomeError(failure.message)), (posts) {
      storiesResult.fold(
        (failure) => emit(HomeError(failure.message)),
        (stories) => emit(HomeLoaded(posts: posts, stories: stories)),
      );
    });
  }

  Future<void> _onLoadMore(
    HomeLoadMoreRequested event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeLoaded) return;
    final currentState = state as HomeLoaded;
    if (currentState.hasReachedMax) return;

    _currentPage++;
    final result = await _getFeedPosts(page: _currentPage);
    result.fold((failure) => emit(HomeError(failure.message)), (newPosts) {
      emit(
        currentState.copyWith(
          posts: [...currentState.posts, ...newPosts],
          hasReachedMax: newPosts.isEmpty,
        ),
      );
    });
  }

  Future<void> _onRefresh(
    HomeRefreshRequested event,
    Emitter<HomeState> emit,
  ) async {
    _currentPage = 1;
    add(HomeFetchRequested());
  }
}
