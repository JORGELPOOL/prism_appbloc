import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/mock/mock_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class CampaignBuilderScreen extends StatelessWidget {
  const CampaignBuilderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final campaigns = MockData.campaignsList;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Campaigns', style: AppTextStyles.pageTitle),
                const Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    color: AppColors.cyan,
                    child: Text('+ New Campaign', style: AppTextStyles.btnPrimary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.separated(
                itemCount: campaigns.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _CampaignCard(data: campaigns[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CampaignCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _CampaignCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final balance = data['pool_remaining'] as double;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgVoid,
        border: Border.all(color: AppColors.border1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(data['campaign_id'], style: AppTextStyles.dataTag),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                color: AppColors.cyan.withValues(alpha: 0.1),
                child: Text('ACTIVE', style: AppTextStyles.dataLabel.copyWith(color: AppColors.cyan)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(data['title'], style: AppTextStyles.sectionHead.copyWith(fontSize: 18)),
          Text(data['client'], style: AppTextStyles.bodyS),
          const SizedBox(height: 16),
          Row(
            children: [
              _Stat('${data['clippers']}', 'Clippers'),
              _Stat('${data['clips_posted']}', 'Clips Posted'),
              _Stat('${(data['total_views'] as int) ~/ 1000}K', 'Total Views'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text('Pool Remaining: ', style: AppTextStyles.dataLabel),
              Text(
                'Rs ${balance.toStringAsFixed(0)}',
                style: AppTextStyles.bodyM.copyWith(
                  color: balance < 5000 ? AppColors.error : AppColors.cyan,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Clipboard.setData(ClipboardData(text: data['access_key'])),
                child: Row(
                  children: [
                    Text('Key: ', style: AppTextStyles.dataLabel),
                    Text(data['access_key'], style: AppTextStyles.dataTag.copyWith(color: AppColors.gold)),
                    const SizedBox(width: 6),
                    const Icon(Icons.copy, color: AppColors.textDim, size: 14),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat(this.value, this.label);

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: AppTextStyles.statMedium.copyWith(fontSize: 20)),
            Text(label, style: AppTextStyles.dataLabel),
          ],
        ),
      );
}
