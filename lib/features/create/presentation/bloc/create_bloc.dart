import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_post.dart';
import '../../domain/usecases/create_story.dart';

part 'create_event.dart';
part 'create_state.dart';

/// BLoC for creating posts and stories.
class CreateBloc extends Bloc<CreateEvent, CreateState> {
  final CreatePost _createPost;
  final CreateStory _createStory;

  CreateBloc({required CreatePost createPost, required CreateStory createStory})
    : _createPost = createPost,
      _createStory = createStory,
      super(CreateInitial()) {
    on<CreatePostRequested>(_onCreatePost);
    on<CreateStoryRequested>(_onCreateStory);
  }

  Future<void> _onCreatePost(
    CreatePostRequested event,
    Emitter<CreateState> emit,
  ) async {
    emit(CreateLoading());
    final result = await _createPost(
      image: event.image,
      caption: event.caption,
    );
    result.fold(
      (failure) => emit(CreateError(failure.message)),
      (_) => emit(const CreateSuccess(message: 'Post created!')),
    );
  }

  Future<void> _onCreateStory(
    CreateStoryRequested event,
    Emitter<CreateState> emit,
  ) async {
    emit(CreateLoading());
    final result = await _createStory(
      image: event.image,
      caption: event.caption,
    );
    result.fold(
      (failure) => emit(CreateError(failure.message)),
      (_) => emit(const CreateSuccess(message: 'Story created!')),
    );
  }
}
