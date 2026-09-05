import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/admin_model.dart';

class SidebarNavItem {
  final String label;
  final IconData icon;
  final int? badgeCount; // red numeric badge (e.g. pending counts)
  final bool showDot; // cyan unread dot

  const SidebarNavItem({
    required this.label,
    required this.icon,
    this.badgeCount,
    this.showDot = false,
  });
}

/// Dark left nav, 220px wide on desktop. On narrow layouts the caller
/// should render [PrismBottomNav] instead (see admin_shell.dart).
///
/// The block at the bottom — avatar/initials, name, and a logout icon —
/// is the admin's profile widget referenced in the spec.
class PrismSidebar extends StatelessWidget {
  final List<SidebarNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final AdminModel admin;
  final VoidCallback onLogout;

  const PrismSidebar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
    required this.admin,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.sidebarWidthDesktop,
      decoration: const BoxDecoration(
        color: AppColors.bgVoid,
        border: Border(right: BorderSide(color: AppColors.border1, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: _Wordmark(),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final selected = index == selectedIndex;
                return _SidebarTile(
                  item: item,
                  selected: selected,
                  onTap: () => onSelect(index),
                );
              },
            ),
          ),
          const Divider(height: 1, color: AppColors.border1),
          _AdminProfileFooter(admin: admin, onLogout: onLogout),
        ],
      ),
    );
  }
}

class _Wordmark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => AppColors.spectrum.createShader(bounds),
          child: Text('X', style: AppTextStyles.sectionHead.copyWith(fontSize: 20, color: Colors.white)),
        ),
        const SizedBox(width: 2),
        Text('PRISM', style: AppTextStyles.sectionHead.copyWith(fontSize: 18)),
      ],
    );
  }
}

class _SidebarTile extends StatelessWidget {
  final SidebarNavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _SidebarTile({required this.item, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.cyan : AppColors.textSilver;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: selected ? AppColors.cyan : Colors.transparent, width: 2)),
          color: selected ? AppColors.bgSurface : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(item.icon, size: 18, color: color),
            const SizedBox(width: 14),
            Flexible(
              child: Text(
                item.label,
                style: AppTextStyles.navItem.copyWith(color: selected ? AppColors.textWhite : AppColors.textSilver),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (item.badgeCount != null && item.badgeCount! > 0) ...[
              const SizedBox(width: 8),
              _CountBadge(count: item.badgeCount!),
            ],
            if (item.showDot) ...[
              const SizedBox(width: 8),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final int count;
  const _CountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 16, maxWidth: 20),
      height: 16,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$count',
        style: AppTextStyles.dataLabel.copyWith(color: AppColors.textWhite, fontSize: 9, height: 1),
      ),
    );
  }
}

/// The "admin profile" element: avatar/initials + name + logout icon,
/// pinned to the bottom of the sidebar.
class _AdminProfileFooter extends StatelessWidget {
  final AdminModel admin;
  final VoidCallback onLogout;

  const _AdminProfileFooter({required this.admin, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.bgSurface,
              border: Border.fromBorderSide(BorderSide(color: AppColors.border2)),
            ),
            child: Text(
              admin.initials,
              style: AppTextStyles.dataTag.copyWith(fontSize: 12, color: AppColors.cyan),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  admin.name,
                  style: AppTextStyles.navItem.copyWith(color: AppColors.textWhite, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  admin.role,
                  style: AppTextStyles.dataLabel,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onLogout,
            icon: const Icon(Icons.logout, size: 18, color: AppColors.textSilver),
            tooltip: 'Log out',
            splashRadius: 18,
          ),
        ],
      ),
    );
  }
}
