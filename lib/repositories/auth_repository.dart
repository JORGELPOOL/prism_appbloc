import '../models/admin_model.dart';

/// Thrown when credentials are rejected by the backend.
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
  @override
  String toString() => message;
}

abstract class AuthRepository {
  /// Logs an admin ("PRISM Team") in and returns their profile.
  Future<AdminModel> adminLogin({required String email, required String password});

  Future<void> logout();
}

/// Temporary in-memory implementation.
///
/// Swap this out for the real implementation once Stone's
/// `POST /auth/admin/login` endpoint is live — the BLoC and screen do not
/// need to change, only this class.
class MockAuthRepository implements AuthRepository {
  @override
  Future<AdminModel> adminLogin({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 700));

    if (email.trim().isEmpty || password.isEmpty) {
      throw const AuthException('Email and password are required.');
    }
    if (!email.contains('@')) {
      throw const AuthException('Enter a valid email address.');
    }
    if (password.length < 6) {
      throw const AuthException('Incorrect email or password.');
    }

    return AdminModel(
      id: 'admin_001',
      name: 'Stone Circle',
      email: email.trim(),
      role: 'Campaign Manager',
    );
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
