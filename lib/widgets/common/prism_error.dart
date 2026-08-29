import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'prism_button.dart';

class PrismError extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const PrismError({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 28),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: AppTextStyles.bodyM),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              PrismButton(label: 'Retry', onPressed: onRetry, variant: PrismButtonVariant.ghost, fullWidth: false),
            ],
          ],
        ),
      ),
    );
  }
}
