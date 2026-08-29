import '../models/admin_dashboard_model.dart';

abstract class AdminRepository {
  Future<AdminDashboardData> getDashboardData();
}

/// Temporary in-memory implementation so the dashboard is fully
/// clickable/demoable before Stone's admin dashboard endpoint exists.
/// Swap for a real Supabase/Dio-backed implementation later —
/// AdminDashboardBloc does not need to change.
class MockAdminRepository implements AdminRepository {
  @override
  Future<AdminDashboardData> getDashboardData() async {
    await Future.delayed(const Duration(milliseconds: 600));

    final now = DateTime.now();

    return AdminDashboardData(
      pendingClipperApprovals: 4,
      pendingClipReviews: 3,
      activeCampaigns: 12,
      totalPoolHeld: 486200,
      paidOutThisMonth: 138450,
      campaigns: [
        const CampaignSummary(
          id: 'PRISM-PARIDA-001',
          clientName: 'Parida Fitness',
          packageType: 'Scale',
          status: CampaignStatus.active,
        ),
        const CampaignSummary(
          id: 'PRISM-FIT-2026',
          clientName: 'FitForge',
          packageType: 'Launch',
          status: CampaignStatus.active,
        ),
        const CampaignSummary(
          id: 'PRISM-VELOX-003',
          clientName: 'Velox Finance',
          packageType: 'Scale',
          status: CampaignStatus.paused,
        ),
        const CampaignSummary(
          id: 'PRISM-NOVA-002',
          clientName: 'Nova Education',
          packageType: 'Launch',
          status: CampaignStatus.draft,
        ),
      ],
      recentActivity: [
        ActivityItem(
          id: 'a1',
          description: 'Rahul Menon submitted a clip',
          timestamp: now.subtract(const Duration(hours: 6)),
          type: ActivityType.clipSubmitted,
        ),
        ActivityItem(
          id: 'a2',
          description: 'Sana Iyer registered as clipper',
          timestamp: now.subtract(const Duration(hours: 20)),
          type: ActivityType.clipperRegistered,
        ),
        ActivityItem(
          id: 'a3',
          description: 'Velox Finance account created',
          timestamp: now.subtract(const Duration(days: 1, hours: 2)),
          type: ActivityType.clientCreated,
        ),
        ActivityItem(
          id: 'a4',
          description: 'Payout run completed — Rs 42,100 to 18 clippers',
          timestamp: now.subtract(const Duration(days: 1, hours: 9)),
          type: ActivityType.payout,
        ),
        ActivityItem(
          id: 'a5',
          description: 'FitForge sent a message',
          timestamp: now.subtract(const Duration(days: 2)),
          type: ActivityType.message,
        ),
      ],
    );
  }
}
