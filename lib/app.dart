import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'blocs/auth/auth_bloc.dart';
import 'core/theme/app_theme.dart';
import 'repositories/auth_repository.dart';
import 'screens/admin/admin_shell.dart';
import 'screens/admin/campaigns/campaign_builder_screen.dart';
import 'screens/admin/clients/admin_clients_screen.dart';
import 'screens/admin/clippers/clipper_approvals_screen.dart';
import 'screens/admin/clips/clip_review_screen.dart';
import 'screens/admin/dashboard/admin_dashboard_screen.dart';
import 'screens/admin/messages/admin_messages_screen.dart';
import 'screens/auth/admin_login_screen.dart';

/// Root widget for PRISM's admin portal.
///
/// Owns the single [AuthBloc] instance and the [GoRouter] built around it:
/// the router's `redirect` reads AuthBloc's state on every navigation
/// attempt, and `refreshListenable` re-runs that redirect whenever the
/// bloc emits (login, logout) — so login/logout navigation is entirely
/// state-driven, no manual `context.go` calls scattered around screens.
class PrismAdminApp extends StatefulWidget {
  const PrismAdminApp({super.key});

  @override
  State<PrismAdminApp> createState() => _PrismAdminAppState();
}

class _PrismAdminAppState extends State<PrismAdminApp> {
  late final AuthBloc _authBloc;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(repository: MockAuthRepository());
    _router = _buildRouter(_authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authBloc,
      child: MaterialApp.router(
        title: 'PRISM — Admin',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        routerConfig: _router,
      ),
    );
  }
}

GoRouter _buildRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: _GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final loggedIn = authBloc.state is AuthSuccess;
      final goingToLogin = state.matchedLocation == '/login';

      if (!loggedIn && !goingToLogin) return '/login';
      if (loggedIn && goingToLogin) return '/admin';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const AdminLoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AdminShell(location: state.matchedLocation, child: child),
        routes: [
          GoRoute(path: '/admin', builder: (_, __) => const AdminDashboardScreen()),
          GoRoute(path: '/admin/clients', builder: (_, __) => const AdminClientsScreen()),
          GoRoute(path: '/admin/clippers', builder: (_, __) => const ClipperApprovalsScreen()),
          GoRoute(path: '/admin/clips', builder: (_, __) => const ClipReviewScreen()),
          GoRoute(path: '/admin/campaigns', builder: (_, __) => const CampaignBuilderScreen()),
          GoRoute(path: '/admin/messages', builder: (_, __) => const AdminMessagesScreen()),
          GoRoute(path: '/admin/analytics', builder: (_, __) => const AdminPlaceholderScreen(title: 'Analytics')),
          GoRoute(path: '/admin/financials', builder: (_, __) => const AdminPlaceholderScreen(title: 'Financials')),
        ],
      ),
    ],
  );
}

/// Adapts a Bloc's state [Stream] into a [Listenable] so go_router's
/// `refreshListenable` re-evaluates `redirect` whenever AuthBloc emits.
class _GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  _GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
