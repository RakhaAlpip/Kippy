part of 'create_bloc.dart';

abstract class CreateState extends Equatable {
  const CreateState();

  @override
  List<Object?> get props => [];
}

class CreateInitial extends CreateState {}

class CreateLoading extends CreateState {}

class CreateSuccess extends CreateState {
  final String message;

  const CreateSuccess({this.message = 'Created successfully!'});

  @override
  List<Object?> get props => [message];
}

class CreateError extends CreateState {
  final String message;

  const CreateError(this.message);

  @override
  List<Object?> get props => [message];
}
