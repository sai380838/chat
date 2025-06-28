part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  final UserModel user;

  Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}
