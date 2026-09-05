import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/mock/mock_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ClipperApprovalsScreen extends StatefulWidget {
  const ClipperApprovalsScreen({super.key});

  @override
  State<ClipperApprovalsScreen> createState() => _ClipperApprovalsScreenState();
}

class _ClipperApprovalsScreenState extends State<ClipperApprovalsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabs;
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Clipper Approvals', style: AppTextStyles.pageTitle),
            const SizedBox(height: 24),
            TabBar(
              controller: _tabs,
              isScrollable: true,
              labelStyle: AppTextStyles.bodyM.copyWith(color: AppColors.textWhite, fontWeight: FontWeight.w600),
              unselectedLabelStyle: AppTextStyles.bodyM,
              indicatorColor: AppColors.cyan,
              indicatorSize: TabBarIndicatorSize.label,
              dividerColor: AppColors.border1,
              tabs: const [Tab(text: 'Pending'), Tab(text: 'Approved'), Tab(text: 'Rejected')],
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(border: Border.all(color: AppColors.border1)),
              child: TextField(
                controller: _search,
                style: AppTextStyles.bodyM.copyWith(color: AppColors.textWhite),
                decoration: InputDecoration(
                  hintText: 'Search by name or handle...',
                  hintStyle: AppTextStyles.bodyM.copyWith(color: AppColors.textDim),
                  prefixIcon: const Icon(Icons.search, color: AppColors.textDim, size: 18),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: TabBarView(
                controller: _tabs,
                children: [
                  _buildPendingList(),
                  _buildEmptyTab('No approved clippers yet'),
                  _buildEmptyTab('No rejected clippers'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingList() {
    final list = MockData.pendingClippersList;
    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, i) => _ClipperCard(data: list[i]),
    );
  }

  Widget _buildEmptyTab(String msg) {
    return Center(child: Text(msg, style: AppTextStyles.bodyM));
  }
}

class _ClipperCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _ClipperCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final score = data['audience_score'] as int;
    final needsLook = score < 65;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgVoid,
        border: Border.all(color: AppColors.border1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data['name'], style: AppTextStyles.sectionHead.copyWith(fontSize: 18)),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () => launchUrl(Uri.parse(data['instagram_link'])),
                            child: Text(data['handle'], style: AppTextStyles.dataTag.copyWith(fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                    Text(data['submitted'], style: AppTextStyles.timestamp),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _Tag(data['niche']),
                    const SizedBox(width: 8),
                    _Tag(data['page_size']),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: needsLook ? AppColors.warning.withValues(alpha: 0.4) : AppColors.border1),
                    color: AppColors.bgSurface,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.shield_outlined, color: AppColors.gold, size: 14),
                          const SizedBox(width: 6),
                          Text('PAGE QUALITY CHECK', style: AppTextStyles.dataLabel),
                          const Spacer(),
                          if (needsLook)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(border: Border.all(color: AppColors.warning)),
                              child: Text(
                                'NEEDS A CLOSER LOOK',
                                style: AppTextStyles.dataLabel.copyWith(color: AppColors.warning),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _Metric('${data['audience_score']}', 'Audience Score'),
                          _Metric('${data['authentic_followers']}%', 'Authentic Followers'),
                          _Metric('${data['engagement']}%', 'Engagement'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Powered by HypeAuditor · this does not block submission', style: AppTextStyles.timestamp),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 48,
                    color: AppColors.cyan,
                    child: Center(child: Text('Approve', style: AppTextStyles.btnPrimary)),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _showRejectDialog(context),
                  child: Container(
                    height: 48,
                    color: AppColors.error,
                    child: Center(
                      child: Text('Reject', style: AppTextStyles.btnPrimary.copyWith(color: AppColors.textWhite)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.bgVoid,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Text('Reject Clipper', style: AppTextStyles.sectionHead.copyWith(fontSize: 18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Provide a reason. This will be sent to the clipper.', style: AppTextStyles.bodyM),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl,
              maxLines: 3,
              style: AppTextStyles.bodyM.copyWith(color: AppColors.textWhite),
              decoration: InputDecoration(
                hintText: 'e.g. Page quality too low, fake followers detected',
                hintStyle: AppTextStyles.bodyM.copyWith(color: AppColors.textDim),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.border2),
                  borderRadius: BorderRadius.zero,
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.cyan),
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: AppTextStyles.bodyM)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Confirm Reject', style: AppTextStyles.btnPrimary.copyWith(color: AppColors.textWhite)),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  const _Tag(this.label);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(border: Border.all(color: AppColors.border2)),
        child: Text(label, style: AppTextStyles.dataLabel.copyWith(color: AppColors.textSilver)),
      );
}

class _Metric extends StatelessWidget {
  final String value;
  final String label;
  const _Metric(this.value, this.label);

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: AppTextStyles.statMedium.copyWith(fontSize: 22)),
            const SizedBox(height: 4),
            Text(label, style: AppTextStyles.bodyS),
          ],
        ),
      );
}
