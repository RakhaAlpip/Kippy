import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiphoto/data/datasources/api_service.dart';

abstract class PostEvent {}
class FetchPosts extends PostEvent {}
abstract class PostState {}
class PostInitial extends PostState {}
class PostLoading extends PostState {}
class PostLoaded extends PostState {
  final List posts;
  PostLoaded(this.posts);
}

class PostBloc extends Bloc<PostEvent, PostState> {
  final ApiService api;
  PostBloc(this.api) : super(PostInitial()) {
    on<FetchPosts>((event, emit) async {
      emit(PostLoading());
      try {
        final response = await api.getPosts();
        emit(PostLoaded(response.data['data']));
      } catch (e) {
      }
    });
  }
}