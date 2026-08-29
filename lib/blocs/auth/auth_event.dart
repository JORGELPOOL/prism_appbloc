part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AdminEmailChanged extends AuthEvent {
  final String email;
  const AdminEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class AdminPasswordChanged extends AuthEvent {
  final String password;
  const AdminPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class AdminPasswordVisibilityToggled extends AuthEvent {
  const AdminPasswordVisibilityToggled();
}

class AdminLoginSubmitted extends AuthEvent {
  const AdminLoginSubmitted();
}

class AdminLogoutRequested extends AuthEvent {
  const AdminLogoutRequested();
}
