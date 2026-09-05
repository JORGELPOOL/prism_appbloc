import 'package:flutter/material.dart';

import '../../../core/mock/mock_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ClipReviewScreen extends StatelessWidget {
  const ClipReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final clips = MockData.pendingClipsList;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Clip Review', style: AppTextStyles.pageTitle),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  color: AppColors.cyan.withValues(alpha: 0.1),
                  child: Text('${clips.length} WAITING', style: AppTextStyles.dataTag),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.separated(
                itemCount: clips.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, i) => _ClipCard(data: clips[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClipCard extends StatefulWidget {
  final Map<String, dynamic> data;
  const _ClipCard({required this.data});

  @override
  State<_ClipCard> createState() => _ClipCardState();
}

class _ClipCardState extends State<_ClipCard> {
  bool _briefExpanded = false;
  bool _showFeedback = false;
  final _feedback = TextEditingController();

  @override
  void dispose() {
    _feedback.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final notes = d['notes'] as String;

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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(d['clipper_name'], style: AppTextStyles.sectionHead.copyWith(fontSize: 16)),
                        Text(d['clipper_handle'], style: AppTextStyles.dataTag.copyWith(fontSize: 11)),
                      ],
                    ),
                    const Spacer(),
                    Text(d['submitted'], style: AppTextStyles.timestamp),
                  ],
                ),
                const SizedBox(height: 12),
                Text(d['campaign_id'], style: AppTextStyles.dataTag),
                const SizedBox(height: 2),
                Text(d['sub_campaign_id'], style: AppTextStyles.timestamp.copyWith(fontSize: 10)),
                const SizedBox(height: 16),
                Container(
                  height: 200,
                  color: AppColors.bgSurface,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.play_circle_outline, color: AppColors.cyan, size: 48),
                        const SizedBox(height: 8),
                        Text('Clip preview loads here', style: AppTextStyles.bodyS),
                      ],
                    ),
                  ),
                ),
                if (notes.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text('Note from clipper:', style: AppTextStyles.dataLabel),
                  const SizedBox(height: 4),
                  Text(notes, style: AppTextStyles.bodyS.copyWith(fontStyle: FontStyle.italic)),
                ],
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => setState(() => _briefExpanded = !_briefExpanded),
                  child: Row(
                    children: [
                      Text('View Brief', style: AppTextStyles.dataTag),
                      const SizedBox(width: 4),
                      Icon(_briefExpanded ? Icons.expand_less : Icons.expand_more, color: AppColors.cyan, size: 16),
                    ],
                  ),
                ),
                if (_briefExpanded) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: AppColors.bgSurface,
                    child: Text(
                      'Hook style: Start with the result. Caption: 2-3 lines max. Do not use music from the restricted list.',
                      style: AppTextStyles.bodyS,
                    ),
                  ),
                ],
                if (_showFeedback) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: _feedback,
                    maxLines: 3,
                    style: AppTextStyles.bodyM.copyWith(color: AppColors.textWhite),
                    decoration: InputDecoration(
                      hintText: 'Specific feedback for the clipper...',
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
              ],
            ),
          ),
          Row(
            children: [
              Expanded(child: _ActionBtn('Approve', AppColors.cyan, AppColors.bgPrimary, () {})),
              Expanded(
                child: _ActionBtn(
                  'Changes Needed',
                  AppColors.warning,
                  AppColors.bgPrimary,
                  () => setState(() => _showFeedback = !_showFeedback),
                ),
              ),
              Expanded(child: _ActionBtn('Reject', AppColors.error, AppColors.textWhite, () {})),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  final VoidCallback onTap;
  const _ActionBtn(this.label, this.bg, this.fg, this.onTap);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          height: 44,
          color: bg,
          child: Center(
            child: Text(label, style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w700)),
          ),
        ),
      );
}
