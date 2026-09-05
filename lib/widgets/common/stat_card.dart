import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'prism_card.dart';

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    this.valueColor = AppColors.textWhite,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PrismCard(
      padding: const EdgeInsets.all(20),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppTextStyles.statMedium.copyWith(fontSize: 36, fontWeight: FontWeight.w800, color: valueColor),
          ),
          const SizedBox(height: 8),
          Text(label.toUpperCase(), style: AppTextStyles.dataLabel),
        ],
      ),
    );
  }
}
