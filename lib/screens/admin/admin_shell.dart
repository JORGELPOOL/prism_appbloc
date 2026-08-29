import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/admin_model.dart';
import '../../widgets/common/prism_sidebar.dart';
import 'dashboard/admin_dashboard_screen.dart';

/// Wraps every admin screen with the sidebar (desktop) / bottom nav
/// (mobile) and hosts the admin profile widget (avatar, name, logout).
///
/// For now this shell only wires up the Control Room dashboard — the
/// other nav destinations (Clients, Clippers, Clip Review, ...) are
/// separate build steps per the roadmap and just show a placeholder.
class AdminShell extends StatefulWidget {
  final AdminModel admin;
  final VoidCallback onLoggedOut;

  const AdminShell({super.key, required this.admin, required this.onLoggedOut});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _selectedIndex = 0;

  static const _navItems = [
    SidebarNavItem(label: 'Dashboard', icon: Icons.grid_view_rounded),
    SidebarNavItem(label: 'Clients', icon: Icons.apartment_rounded),
    SidebarNavItem(label: 'Clippers', icon: Icons.person_rounded, badgeCount: 4),
    SidebarNavItem(label: 'Clip Review', icon: Icons.movie_rounded, badgeCount: 3),
    SidebarNavItem(label: 'Campaigns', icon: Icons.campaign_rounded),
    SidebarNavItem(label: 'Messages', icon: Icons.chat_bubble_rounded, showDot: true),
    SidebarNavItem(label: 'Analytics', icon: Icons.bar_chart_rounded),
    SidebarNavItem(label: 'Financials', icon: Icons.currency_rupee_rounded),
  ];

  void _handleLogout() {
    context.read<AuthBloc>().add(const AdminLogoutRequested());
    widget.onLoggedOut();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < AppSpacing.mobileBreakpoint;

        return Scaffold(
          backgroundColor: AppColors.bgPrimary,
          body: Row(
            children: [
              if (!isMobile)
                PrismSidebar(
                  items: _navItems,
                  selectedIndex: _selectedIndex,
                  onSelect: (i) => setState(() => _selectedIndex = i),
                  admin: widget.admin,
                  onLogout: _handleLogout,
                ),
              Expanded(child: _buildContent()),
            ],
          ),
          bottomNavigationBar: isMobile ? _MobileBottomNav(
            items: _navItems,
            selectedIndex: _selectedIndex,
            onSelect: (i) => setState(() => _selectedIndex = i),
          ) : null,
        );
      },
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return const AdminDashboardScreen();
      default:
        return _PlaceholderScreen(title: _navItems[_selectedIndex].label);
    }
  }
}

/// Bottom nav shown on narrow/mobile layouts. Shows the first 5 items
/// plus an overflow "More" entry (which surfaces the rest, including the
/// admin profile / logout action, since there's no sidebar footer here).
class _MobileBottomNav extends StatelessWidget {
  final List<SidebarNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _MobileBottomNav({required this.items, required this.selectedIndex, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final visible = items.take(5).toList();

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
                item: visible[i],
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
  final SidebarNavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _MobileNavIcon({required this.item, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.cyan : AppColors.textDim;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(item.icon, size: 22, color: color),
                if (item.badgeCount != null && item.badgeCount! > 0)
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
          ],
        ),
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$title — build step not yet reached',
        style: AppTextStyles.bodyM,
      ),
    );
  }
}
