import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/register.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/get_authenticated_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// BLoC handling authentication state.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login _login;
  final Register _register;
  final Logout _logout;
  final GetAuthenticatedUser _getAuthenticatedUser;

  AuthBloc({
    required Login login,
    required Register register,
    required Logout logout,
    required GetAuthenticatedUser getAuthenticatedUser,
  }) : _login = login,
       _register = register,
       _logout = logout,
       _getAuthenticatedUser = getAuthenticatedUser,
       super(AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = await _getAuthenticatedUser();
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      print('AuthBloc: Attempting login for ${event.email}');
      final result = await _login(email: event.email, password: event.password);
      print('AuthBloc: Login result received');
      result.fold(
        (failure) {
          print('AuthBloc: Login failure: ${failure.message}');
          emit(AuthError(failure.message));
        },
        (user) {
          print('AuthBloc: Login success for ${user.username}');
          emit(AuthAuthenticated(user));
        },
      );
    } catch (e) {
      print('AuthBloc: Unexpected error during login: $e');
      emit(AuthError('An unexpected error occurred: $e'));
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await _register(
        username: event.username,
        email: event.email,
        password: event.password,
      );
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (user) => emit(AuthAuthenticated(user)),
      );
    } catch (e) {
      emit(AuthError('An unexpected error occurred: $e'));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await _logout();
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (_) => emit(AuthUnauthenticated()),
      );
    } catch (e) {
      emit(AuthError('An unexpected error occurred: $e'));
    }
  }
}
