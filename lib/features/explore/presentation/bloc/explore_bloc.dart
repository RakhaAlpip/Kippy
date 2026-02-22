import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/domain/entities/post.dart';
import '../../domain/usecases/get_explore_posts.dart';

part 'explore_event.dart';
part 'explore_state.dart';

/// BLoC for the Explore page.
class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final GetExplorePosts _getExplorePosts;
  int _currentPage = 1;

  ExploreBloc({required GetExplorePosts getExplorePosts})
    : _getExplorePosts = getExplorePosts,
      super(ExploreInitial()) {
    on<ExploreFetchRequested>(_onFetchRequested);
    on<ExploreLoadMoreRequested>(_onLoadMore);
  }

  Future<void> _onFetchRequested(
    ExploreFetchRequested event,
    Emitter<ExploreState> emit,
  ) async {
    emit(ExploreLoading());
    _currentPage = 1;
    final result = await _getExplorePosts(page: _currentPage);
    result.fold(
      (failure) => emit(ExploreError(failure.message)),
      (posts) => emit(ExploreLoaded(posts: posts)),
    );
  }

  Future<void> _onLoadMore(
    ExploreLoadMoreRequested event,
    Emitter<ExploreState> emit,
  ) async {
    if (state is! ExploreLoaded) return;
    final currentState = state as ExploreLoaded;
    if (currentState.hasReachedMax) return;

    _currentPage++;
    final result = await _getExplorePosts(page: _currentPage);
    result.fold(
      (failure) => emit(ExploreError(failure.message)),
      (newPosts) => emit(
        ExploreLoaded(
          posts: [...currentState.posts, ...newPosts],
          hasReachedMax: newPosts.isEmpty,
        ),
      ),
    );
  }
}
