part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;

  LoginSubmitted(this.email, this.password);
}

class RegisterSubmitted extends AuthEvent {
  final UserModel user;
  final String password;

  RegisterSubmitted(this.user, this.password);
}

class LogoutRequested extends AuthEvent {}
