import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/admin_model.dart';
import '../../repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// Drives the Admin Login screen (Auth — Screen 4).
///
/// The bloc tracks the in-progress email/password internally rather than
/// in the emitted state, so [AuthState] stays a clean four-state machine
/// (Initial / Loading / Success / Failure) as specified. The screen keeps
/// its own TextEditingControllers and just dispatches change events so the
/// bloc has valid values to submit.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  String _email = '';
  String _password = '';

  AuthBloc({required this.repository}) : super(const AuthInitial()) {
    on<AdminEmailChanged>(_onEmailChanged);
    on<AdminPasswordChanged>(_onPasswordChanged);
    on<AdminLoginSubmitted>(_onSubmitted);
    on<AdminLogoutRequested>(_onLogout);
  }

  void _onEmailChanged(AdminEmailChanged event, Emitter<AuthState> emit) {
    _email = event.email;
  }

  void _onPasswordChanged(AdminPasswordChanged event, Emitter<AuthState> emit) {
    _password = event.password;
  }

  Future<void> _onSubmitted(AdminLoginSubmitted event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final admin = await repository.adminLogin(email: _email, password: _password);
      emit(AuthSuccess(admin));
    } on AuthException catch (e) {
      emit(AuthFailure(e.message));
    } catch (e) {
      emit(const AuthFailure('Something went wrong. Try again.'));
    }
  }

  Future<void> _onLogout(AdminLogoutRequested event, Emitter<AuthState> emit) async {
    await repository.logout();
    emit(const AuthLoggedOut());
  }
}
