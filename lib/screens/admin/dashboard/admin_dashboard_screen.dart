import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/admin/dashboard/admin_dashboard_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/admin_dashboard_model.dart';
import '../../../repositories/admin_repository.dart';
import '../../../widgets/common/prism_badge.dart';
import '../../../widgets/common/prism_button.dart';
import '../../../widgets/common/prism_card.dart';
import '../../../widgets/common/prism_error.dart';
import '../../../widgets/common/prism_loader.dart';
import '../../../widgets/common/stat_card.dart';

/// Admin — Screen 1: Control Room Dashboard.
/// First screen admin sees on login. Overview of everything.
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminDashboardBloc(repository: MockAdminRepository())..add(const LoadDashboard()),
      child: const _AdminDashboardView(),
    );
  }
}

class _AdminDashboardView extends StatelessWidget {
  const _AdminDashboardView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminDashboardBloc, AdminDashboardState>(
      builder: (context, state) {
        if (state is AdminDashboardLoading || state is AdminDashboardInitial) {
          return const PrismLoader();
        }
        if (state is AdminDashboardError) {
          return PrismError(
            message: state.message,
            onRetry: () => context.read<AdminDashboardBloc>().add(const LoadDashboard()),
          );
        }

        final data = (state as AdminDashboardLoaded).data;

        return RefreshIndicator(
          color: AppColors.cyan,
          backgroundColor: AppColors.bgVoid,
          onRefresh: () async {
            context.read<AdminDashboardBloc>().add(const RefreshDashboard());
            await context.read<AdminDashboardBloc>().stream.firstWhere(
                  (s) => s is AdminDashboardLoaded && !s.isRefreshing,
                );
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Control Room', style: AppTextStyles.pageTitle),
                const SizedBox(height: 32),

                _StatRow(data: data),
                const SizedBox(height: 32),

                _QuickActions(data: data),
                const SizedBox(height: 48),

                Text('ACTIVE CAMPAIGNS', style: AppTextStyles.dataLabel),
                const SizedBox(height: 12),
                _CampaignList(campaigns: data.campaigns),
                const SizedBox(height: 48),

                Text('RECENT ACTIVITY', style: AppTextStyles.dataLabel),
                const SizedBox(height: 12),
                _ActivityFeed(activity: data.recentActivity),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatRow extends StatelessWidget {
  final AdminDashboardData data;
  const _StatRow({required this.data});

  /// Indian digit grouping: last 3 digits together, then groups of 2.
  /// e.g. 486200 -> "4,86,200", 5000000 -> "50,00,000".
  String _rs(double amount) {
    final s = amount.toStringAsFixed(0);
    if (s.length <= 3) return 'Rs $s';

    final last3 = s.substring(s.length - 3);
    final rest = s.substring(0, s.length - 3);

    final groups = <String>[];
    var remaining = rest;
    while (remaining.length > 2) {
      groups.insert(0, remaining.substring(remaining.length - 2));
      remaining = remaining.substring(0, remaining.length - 2);
    }
    if (remaining.isNotEmpty) groups.insert(0, remaining);

    return 'Rs ${groups.join(',')},$last3';
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 900;
        final cards = [
          StatCard(
            value: '${data.pendingClipperApprovals}',
            label: 'Pending Clipper Approvals',
            valueColor: data.pendingClipperApprovals > 0 ? AppColors.error : AppColors.textWhite,
          ),
          StatCard(
            value: '${data.pendingClipReviews}',
            label: 'Pending Clip Reviews',
            valueColor: data.pendingClipReviews > 0 ? AppColors.error : AppColors.textWhite,
          ),
          StatCard(
            value: '${data.activeCampaigns}',
            label: 'Active Campaigns',
            valueColor: AppColors.textWhite,
          ),
          StatCard(
            value: _rs(data.totalPoolHeld),
            label: 'Total Pool Held',
            valueColor: AppColors.cyan,
          ),
          StatCard(
            value: _rs(data.paidOutThisMonth),
            label: 'Paid Out This Month',
            valueColor: AppColors.gold,
          ),
        ];

        if (isNarrow) {
          return GridView.count(
            crossAxisCount: constraints.maxWidth < 520 ? 1 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.7,
            children: cards,
          );
        }

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int i = 0; i < cards.length; i++) ...[
                Expanded(child: cards[i]),
                if (i != cards.length - 1) const SizedBox(width: 16),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _QuickActions extends StatelessWidget {
  final AdminDashboardData data;
  const _QuickActions({required this.data});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        SizedBox(
          width: 220,
          child: PrismButton(
            label: 'Review Pending Clippers',
            variant: data.pendingClipperApprovals > 0 ? PrismButtonVariant.primary : PrismButtonVariant.ghost,
            onPressed: () {},
          ),
        ),
        SizedBox(
          width: 220,
          child: PrismButton(
            label: 'Review Pending Clips',
            variant: data.pendingClipReviews > 0 ? PrismButtonVariant.primary : PrismButtonVariant.ghost,
            onPressed: () {},
          ),
        ),
        SizedBox(
          width: 220,
          child: PrismButton(label: 'Campaign Analytics', variant: PrismButtonVariant.ghost, onPressed: () {}),
        ),
        SizedBox(
          width: 220,
          child: PrismButton(label: 'Financial Dashboard', variant: PrismButtonVariant.ghost, onPressed: () {}),
        ),
      ],
    );
  }
}

class _CampaignList extends StatelessWidget {
  final List<CampaignSummary> campaigns;
  const _CampaignList({required this.campaigns});

  PrismBadgeStatus _status(CampaignStatus s) {
    switch (s) {
      case CampaignStatus.active:
        return PrismBadgeStatus.active;
      case CampaignStatus.paused:
        return PrismBadgeStatus.paused;
      case CampaignStatus.draft:
        return PrismBadgeStatus.draft;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (campaigns.isEmpty) {
      return Text('No active campaigns yet.', style: AppTextStyles.bodyM);
    }

    return PrismCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (int i = 0; i < campaigns.length; i++)
            InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: i == campaigns.length - 1 ? Colors.transparent : AppColors.border1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: campaigns[i].clientName, style: AppTextStyles.bodyL.copyWith(fontSize: 15, color: AppColors.textWhite)),
                            TextSpan(text: '  ·  ${campaigns[i].packageType}', style: AppTextStyles.bodyM),
                          ],
                        ),
                      ),
                    ),
                    PrismBadge(label: campaigns[i].status.name, status: _status(campaigns[i].status)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ActivityFeed extends StatelessWidget {
  final List<ActivityItem> activity;
  const _ActivityFeed({required this.activity});

  IconData _iconFor(ActivityType type) {
    switch (type) {
      case ActivityType.clipSubmitted:
        return Icons.movie_creation_outlined;
      case ActivityType.clipperRegistered:
        return Icons.person_add_alt_1_outlined;
      case ActivityType.clientCreated:
        return Icons.apartment_outlined;
      case ActivityType.payout:
        return Icons.currency_rupee_rounded;
      case ActivityType.message:
        return Icons.chat_bubble_outline_rounded;
      case ActivityType.other:
        return Icons.circle_outlined;
    }
  }

  String _relativeTime(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final items = activity.take(10).toList();
    if (items.isEmpty) {
      return Text('Nothing yet.', style: AppTextStyles.bodyM);
    }

    return PrismCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: i == items.length - 1 ? Colors.transparent : AppColors.border1),
                ),
              ),
              child: Row(
                children: [
                  Icon(_iconFor(items[i].type), size: 16, color: AppColors.textSilver),
                  const SizedBox(width: 14),
                  Expanded(child: Text(items[i].description, style: AppTextStyles.bodyM.copyWith(color: AppColors.textMist))),
                  Text(_relativeTime(items[i].timestamp), style: AppTextStyles.timestamp),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
