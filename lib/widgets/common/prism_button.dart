import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

enum PrismButtonVariant { primary, ghost, danger }

class PrismButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final PrismButtonVariant variant;
  final bool isLoading;
  final bool fullWidth;
  final IconData? icon;

  const PrismButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = PrismButtonVariant.primary,
    this.isLoading = false,
    this.fullWidth = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null || isLoading;

    Color background;
    Color foreground;
    Border? border;

    switch (variant) {
      case PrismButtonVariant.primary:
        background = disabled ? AppColors.cyan.withValues(alpha: 0.35) : AppColors.cyan;
        foreground = AppColors.bgPrimary;
        border = null;
        break;
      case PrismButtonVariant.ghost:
        background = Colors.transparent;
        foreground = disabled ? AppColors.textDim : AppColors.textWhite;
        border = Border.all(color: AppColors.border2, width: 1);
        break;
      case PrismButtonVariant.danger:
        background = disabled ? AppColors.error.withValues(alpha: 0.35) : AppColors.error;
        foreground = AppColors.textWhite;
        border = null;
        break;
    }

    final child = isLoading
        ? SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(strokeWidth: 2, color: foreground),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: foreground),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: AppTextStyles.btnPrimary.copyWith(color: foreground),
              ),
            ],
          );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 48,
      child: Material(
        color: background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: border?.top ?? BorderSide.none,
        ),
        child: InkWell(
          onTap: disabled ? null : onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
