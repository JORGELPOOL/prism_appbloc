import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/auth/auth_bloc.dart';
import 'core/theme/app_theme.dart';
import 'models/admin_model.dart';
import 'repositories/auth_repository.dart';
import 'screens/admin/admin_shell.dart';
import 'screens/auth/admin_login_screen.dart';

/// Root widget for this slice of PRISM (Admin Login -> Control Room).
///
/// This deliberately does not wire up go_router yet — that's a later
/// build step ("Set up go_router with role-based redirect"). For now,
/// AuthBloc's state is used directly to switch between the login screen
/// and the admin shell, which is enough to demo and test this step in
/// isolation before it's dropped into the full app_router setup.
class PrismAdminApp extends StatelessWidget {
  const PrismAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(repository: MockAuthRepository()),
      child: MaterialApp(
        title: 'PRISM — Admin',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const _AuthGate(),
      ),
    );
  }
}

class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  AdminModel? _admin;

  @override
  Widget build(BuildContext context) {
    if (_admin == null) {
      return AdminLoginScreen(
        onLoginSuccess: () {
          final state = context.read<AuthBloc>().state;
          if (state is AuthSuccess) {
            setState(() => _admin = state.admin);
          }
        },
      );
    }

    return AdminShell(
      admin: _admin!,
      onLoggedOut: () => setState(() => _admin = null),
    );
  }
}
