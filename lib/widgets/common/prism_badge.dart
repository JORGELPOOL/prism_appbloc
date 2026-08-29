import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

enum PrismBadgeStatus { pending, approved, rejected, active, paused, draft }

class PrismBadge extends StatelessWidget {
  final String label;
  final PrismBadgeStatus status;

  const PrismBadge({super.key, required this.label, required this.status});

  Color get _color {
    switch (status) {
      case PrismBadgeStatus.pending:
        return AppColors.warning;
      case PrismBadgeStatus.approved:
      case PrismBadgeStatus.active:
        return AppColors.mint;
      case PrismBadgeStatus.rejected:
        return AppColors.error;
      case PrismBadgeStatus.paused:
        return AppColors.textSilver;
      case PrismBadgeStatus.draft:
        return AppColors.textDim;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.dataTag.copyWith(color: color),
      ),
    );
  }
}

/// Section label with a horizontal rule extending to the right —
/// JetBrains Mono 10px Cyan.
class PrismLabel extends StatelessWidget {
  final String text;

  const PrismLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(text.toUpperCase(), style: AppTextStyles.dataTag),
        const SizedBox(width: 12),
        Expanded(child: Container(height: 1, color: AppColors.border1)),
      ],
    );
  }
}
