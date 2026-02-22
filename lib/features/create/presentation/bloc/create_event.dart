part of 'create_bloc.dart';

abstract class CreateEvent extends Equatable {
  const CreateEvent();

  @override
  List<Object?> get props => [];
}

class CreatePostRequested extends CreateEvent {
  final File image;
  final String caption;

  const CreatePostRequested({required this.image, required this.caption});

  @override
  List<Object?> get props => [image, caption];
}

class CreateStoryRequested extends CreateEvent {
  final File image;
  final String? caption;

  const CreateStoryRequested({required this.image, this.caption});

  @override
  List<Object?> get props => [image, caption];
}
