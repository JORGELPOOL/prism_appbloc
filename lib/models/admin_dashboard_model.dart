import 'package:equatable/equatable.dart';

enum CampaignStatus { draft, active, paused }

class CampaignSummary extends Equatable {
  final String id; // e.g. PRISM-FIT-2026
  final String clientName;
  final String packageType; // "Launch" / "Scale"
  final CampaignStatus status;

  const CampaignSummary({
    required this.id,
    required this.clientName,
    required this.packageType,
    required this.status,
  });

  @override
  List<Object?> get props => [id, clientName, packageType, status];
}

class ActivityItem extends Equatable {
  final String id;
  final String description; // e.g. "Rahul Menon submitted a clip"
  final DateTime timestamp;
  final ActivityType type;

  const ActivityItem({
    required this.id,
    required this.description,
    required this.timestamp,
    required this.type,
  });

  @override
  List<Object?> get props => [id, description, timestamp, type];
}

enum ActivityType { clipSubmitted, clipperRegistered, clientCreated, payout, message, other }

/// Aggregate payload for the Control Room dashboard.
class AdminDashboardData extends Equatable {
  final int pendingClipperApprovals;
  final int pendingClipReviews;
  final int activeCampaigns;
  final double totalPoolHeld; // Rs
  final double paidOutThisMonth; // Rs
  final List<CampaignSummary> campaigns;
  final List<ActivityItem> recentActivity;

  const AdminDashboardData({
    required this.pendingClipperApprovals,
    required this.pendingClipReviews,
    required this.activeCampaigns,
    required this.totalPoolHeld,
    required this.paidOutThisMonth,
    required this.campaigns,
    required this.recentActivity,
  });

  @override
  List<Object?> get props => [
        pendingClipperApprovals,
        pendingClipReviews,
        activeCampaigns,
        totalPoolHeld,
        paidOutThisMonth,
        campaigns,
        recentActivity,
      ];
}
