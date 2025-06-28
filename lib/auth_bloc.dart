import 'package:chat/auth_repo.dart';
import 'package:chat/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';


part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc(this._repository) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginSubmitted>(_onLogin);
    on<RegisterSubmitted>(_onRegister);
    on<LogoutRequested>(_onLogout);
  }

  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final user = await _repository.getUser();
    if (user != null) {
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  void _onLogin(LoginSubmitted event, Emitter<AuthState> emit) async {
  try {
    final user = await _repository.login(email: event.email, password: event.password);
    emit(Authenticated(user!));
  } catch (e) {
    emit(AuthFailure("Login failed: ${e.toString()}"));
  }
}

void _onRegister(RegisterSubmitted event, Emitter<AuthState> emit) async {
  try {
    final user = await _repository.register(
      email: event.user.email,
      password: event.password,
      displayName: event.user.displayName,
      mobile: event.user.mobile,
      country: event.user.country,
      token: event.user.token,
    );
    emit(Authenticated(user!));
  } catch (e) {
    emit(AuthFailure("Registration failed: ${e.toString()}"));
  }
}



  void _onLogout(LogoutRequested event, Emitter<AuthState> emit) async {
    await _repository.logout();
    emit(Unauthenticated());
  }
}
