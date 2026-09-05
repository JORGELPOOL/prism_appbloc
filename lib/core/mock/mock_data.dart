/// All dummy data in one place. Every screen uses this until real APIs
/// are connected — swap individual lists out for repository calls later,
/// screen code doesn't need to change shape since it's already reading
/// from `Map<String, dynamic>` here, matching what the API will return.
class MockData {
  // DASHBOARD
  static const int pendingClippers = 4;
  static const int pendingClips = 3;
  static const int activeCampaigns = 12;
  static const double totalPoolHeld = 486200;
  static const double paidOutThisMonth = 138450;

  // CLIPPERS
  static const List<Map<String, dynamic>> pendingClippersList = [
    {
      "id": "1",
      "name": "Sana Iyer",
      "handle": "@sanaiyer.fit",
      "niche": "Fitness",
      "page_size": "5K-20K",
      "instagram_link": "https://instagram.com/sanaiyer.fit",
      "audience_score": 61,
      "authentic_followers": 68,
      "engagement": 2.1,
      "submitted": "20h ago",
    },
    {
      "id": "2",
      "name": "Dev Patel",
      "handle": "@devpatel.money",
      "niche": "Finance",
      "page_size": "20K-100K",
      "instagram_link": "https://instagram.com/devpatel.money",
      "audience_score": 78,
      "authentic_followers": 82,
      "engagement": 3.4,
      "submitted": "3h ago",
    },
    {
      "id": "3",
      "name": "Rahul Menon",
      "handle": "@rahulmenon_biz",
      "niche": "Business",
      "page_size": "5K-20K",
      "instagram_link": "https://instagram.com/rahulmenon_biz",
      "audience_score": 55,
      "authentic_followers": 71,
      "engagement": 1.8,
      "submitted": "1d ago",
    },
    {
      "id": "4",
      "name": "Priya Shah",
      "handle": "@priya.trades",
      "niche": "Finance",
      "page_size": "5K-20K",
      "instagram_link": "https://instagram.com/priya.trades",
      "audience_score": 70,
      "authentic_followers": 75,
      "engagement": 2.8,
      "submitted": "2d ago",
    },
  ];

  // CLIENTS
  static const List<Map<String, dynamic>> clientsList = [
    {
      "id": "1",
      "name": "Abhinabh Parida",
      "business": "ParidaFX",
      "package": "Scale",
      "niche": "Finance",
      "pool_balance": 48200.0,
      "status": "active",
      "clips_this_month": 42,
      "joined": "Jan 2026",
    },
    {
      "id": "2",
      "name": "FitPro India",
      "business": "FitPro",
      "package": "Launch",
      "niche": "Fitness",
      "pool_balance": 12800.0,
      "status": "active",
      "clips_this_month": 18,
      "joined": "Feb 2026",
    },
    {
      "id": "3",
      "name": "BrandCo",
      "business": "BrandCo",
      "package": "Launch",
      "niche": "Business",
      "pool_balance": 1800.0,
      "status": "active",
      "clips_this_month": 9,
      "joined": "Mar 2026",
    },
  ];

  // PENDING CLIP REVIEWS
  static const List<Map<String, dynamic>> pendingClipsList = [
    {
      "id": "1",
      "clipper_name": "Rahul Menon",
      "clipper_handle": "@rahulmenon_biz",
      "campaign_id": "PRISM-PARIDA-001",
      "sub_campaign_id": "PRISM-PARIDA-001-V03",
      "submitted": "6h ago",
      "notes": "Used transformation hook as briefed",
      "clip_url": "",
    },
    {
      "id": "2",
      "clipper_name": "Sana Iyer",
      "clipper_handle": "@sanaiyer.fit",
      "campaign_id": "PRISM-FITPRO-001",
      "sub_campaign_id": "PRISM-FITPRO-001-V01",
      "submitted": "1h ago",
      "notes": "",
      "clip_url": "",
    },
    {
      "id": "3",
      "clipper_name": "Dev Patel",
      "clipper_handle": "@devpatel.money",
      "campaign_id": "PRISM-PARIDA-001",
      "sub_campaign_id": "PRISM-PARIDA-001-V01",
      "submitted": "3h ago",
      "notes": "Bold text hook style used",
      "clip_url": "",
    },
  ];

  // CAMPAIGNS
  static const List<Map<String, dynamic>> campaignsList = [
    {
      "id": "1",
      "campaign_id": "PRISM-PARIDA-001",
      "client": "ParidaFX",
      "title": "Trading Mindset Series",
      "status": "active",
      "clippers": 15,
      "clips_posted": 42,
      "total_views": 184000,
      "pool_remaining": 48200.0,
      "access_key": "PRISM-FIN-2026",
    },
    {
      "id": "2",
      "campaign_id": "PRISM-FITPRO-001",
      "client": "FitPro",
      "title": "Fat Loss Education",
      "status": "active",
      "clippers": 8,
      "clips_posted": 18,
      "total_views": 94000,
      "pool_remaining": 12800.0,
      "access_key": "PRISM-FIT-2026",
    },
  ];

  // MESSAGES
  static const List<Map<String, dynamic>> messagesList = [
    {
      "client_id": "1",
      "client_name": "Abhinabh Parida",
      "last_message": "When will the next batch go live?",
      "timestamp": "2h ago",
      "unread": true,
    },
    {
      "client_id": "2",
      "client_name": "FitPro India",
      "last_message": "Pool is getting low, topping up soon.",
      "timestamp": "1d ago",
      "unread": false,
    },
  ];

  static const List<Map<String, dynamic>> threadMessages = [
    {"sender": "client", "message": "Hey, when is the next clip batch going out?", "time": "10:24 AM"},
    {"sender": "admin", "message": "Going out tomorrow morning. 12 clips across all pages.", "time": "10:31 AM"},
    {"sender": "client", "message": "Great! Pool is at Rs 48,200 still good right?", "time": "10:33 AM"},
    {"sender": "admin", "message": "Yes comfortably. At current burn rate covers 3 more weeks.", "time": "10:35 AM"},
    {"sender": "client", "message": "When will the next batch go live?", "time": "2h ago"},
  ];

  // RECENT ACTIVITY
  static const List<Map<String, dynamic>> recentActivity = [
    {"icon": "upload", "text": "Rahul Menon submitted a clip", "time": "6h ago"},
    {"icon": "person", "text": "Sana Iyer registered as clipper", "time": "20h ago"},
    {"icon": "check", "text": "Dev Patel clip approved", "time": "1d ago"},
    {"icon": "money", "text": "ParidaFX pool topped up Rs 50,000", "time": "2d ago"},
    {"icon": "campaign", "text": "PRISM-FITPRO-001 campaign activated", "time": "3d ago"},
  ];
}
