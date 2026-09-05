import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/prism_sidebar.dart';

class AdminNavDestination {
  final String label;
  final IconData icon;
  final String path;
  final int? badgeCount;
  final bool showDot;

  const AdminNavDestination({
    required this.label,
    required this.icon,
    required this.path,
    this.badgeCount,
    this.showDot = false,
  });
}

/// The full nav map, in sidebar order. Shared between the sidebar,
/// the mobile bottom nav, and route registration in app.dart.
const List<AdminNavDestination> adminNavDestinations = [
  AdminNavDestination(label: 'Dashboard', icon: Icons.grid_view_rounded, path: '/admin'),
  AdminNavDestination(label: 'Clients', icon: Icons.apartment_rounded, path: '/admin/clients'),
  AdminNavDestination(label: 'Clippers', icon: Icons.person_rounded, path: '/admin/clippers', badgeCount: 4),
  AdminNavDestination(label: 'Clip Review', icon: Icons.movie_rounded, path: '/admin/clips', badgeCount: 3),
  AdminNavDestination(label: 'Campaigns', icon: Icons.campaign_rounded, path: '/admin/campaigns'),
  AdminNavDestination(label: 'Messages', icon: Icons.chat_bubble_rounded, path: '/admin/messages', showDot: true),
  AdminNavDestination(label: 'Analytics', icon: Icons.bar_chart_rounded, path: '/admin/analytics'),
  AdminNavDestination(label: 'Financials', icon: Icons.currency_rupee_rounded, path: '/admin/financials'),
];

/// Wraps every admin screen with the sidebar (desktop) / bottom nav
/// (mobile) and hosts the admin profile widget (avatar, name, logout).
/// Used as the builder for go_router's admin ShellRoute — [child] is
/// whatever the matched nested route renders.
class AdminShell extends StatelessWidget {
  final String location;
  final Widget child;

  const AdminShell({super.key, required this.location, required this.child});

  int get _selectedIndex {
    // Exact match first (dashboard root), then prefix match for nested paths.
    final exact = adminNavDestinations.indexWhere((d) => d.path == location);
    if (exact != -1) return exact;
    final prefix = adminNavDestinations.indexWhere((d) => d.path != '/admin' && location.startsWith(d.path));
    return prefix == -1 ? 0 : prefix;
  }

  void _handleLogout(BuildContext context) {
    context.read<AuthBloc>().add(const AdminLogoutRequested());
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final admin = authState is AuthSuccess ? authState.admin : null;

    // Shouldn't happen in practice — the router redirect keeps unauthenticated
    // users off /admin routes — but guard anyway rather than crash on a null admin.
    if (admin == null) {
      return const Scaffold(backgroundColor: AppColors.bgPrimary, body: SizedBox.shrink());
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < AppSpacing.mobileBreakpoint;
        final selectedIndex = _selectedIndex;

        return Scaffold(
          backgroundColor: AppColors.bgPrimary,
          body: Row(
            children: [
              if (!isMobile)
                PrismSidebar(
                  items: adminNavDestinations
                      .map((d) => SidebarNavItem(label: d.label, icon: d.icon, badgeCount: d.badgeCount, showDot: d.showDot))
                      .toList(),
                  selectedIndex: selectedIndex,
                  onSelect: (i) => context.go(adminNavDestinations[i].path),
                  admin: admin,
                  onLogout: () => _handleLogout(context),
                ),
              Expanded(child: child),
            ],
          ),
          bottomNavigationBar: isMobile
              ? _MobileBottomNav(
                  selectedIndex: selectedIndex,
                  onSelect: (i) => context.go(adminNavDestinations[i].path),
                )
              : null,
        );
      },
    );
  }
}

/// Bottom nav shown on narrow/mobile layouts. Shows the first 5 items;
/// the rest (plus the admin profile / logout action) are reachable once
/// a "More" sheet is added — out of scope for this pass.
class _MobileBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _MobileBottomNav({required this.selectedIndex, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final visible = adminNavDestinations.take(5).toList();

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgVoid,
        border: Border(top: BorderSide(color: AppColors.border1, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i = 0; i < visible.length; i++)
              _MobileNavIcon(
                destination: visible[i],
                selected: i == selectedIndex,
                onTap: () => onSelect(i),
              ),
          ],
        ),
      ),
    );
  }
}

class _MobileNavIcon extends StatelessWidget {
  final AdminNavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  const _MobileNavIcon({required this.destination, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.cyan : AppColors.textDim;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(destination.icon, size: 22, color: color),
            if (destination.badgeCount != null && destination.badgeCount! > 0)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder for nav destinations that don't have a real screen yet
/// (Analytics, Financials — separate build steps per the roadmap).
class AdminPlaceholderScreen extends StatelessWidget {
  final String title;
  const AdminPlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Center(
        child: Text('$title — build step not yet reached', style: AppTextStyles.bodyM),
      ),
    );
  }
}
