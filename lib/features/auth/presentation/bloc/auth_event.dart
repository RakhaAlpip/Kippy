part of 'auth_bloc.dart';

/// Events for the AuthBloc.
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event: Check if user is already authenticated (on app start).
class AuthCheckRequested extends AuthEvent {}

/// Event: User attempts to login.
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// Event: User attempts to register.
class AuthRegisterRequested extends AuthEvent {
  final String username;
  final String email;
  final String password;

  const AuthRegisterRequested({
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [username, email, password];
}

/// Event: User logs out.
class AuthLogoutRequested extends AuthEvent {}
