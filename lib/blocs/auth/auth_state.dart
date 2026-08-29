part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final AdminModel admin;
  const AuthSuccess(this.admin);

  @override
  List<Object?> get props => [admin];
}

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Emitted after AdminLogoutRequested completes — screens listen for this
/// to route back to admin_login_screen.
class AuthLoggedOut extends AuthState {
  const AuthLoggedOut();
}
