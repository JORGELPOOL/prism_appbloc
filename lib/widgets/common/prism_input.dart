import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class PrismInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final Widget? trailing;
  final String? errorText;
  final TextInputType? keyboardType;
  final bool autoUppercase;

  const PrismInput({
    super.key,
    required this.label,
    required this.controller,
    this.onChanged,
    this.obscureText = false,
    this.trailing,
    this.errorText,
    this.keyboardType,
    this.autoUppercase = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.inputLabel),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textCapitalization: autoUppercase ? TextCapitalization.characters : TextCapitalization.none,
          style: AppTextStyles.inputText,
          cursorColor: AppColors.cyan,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            border: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.border2)),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: hasError ? AppColors.error : AppColors.border2),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: hasError ? AppColors.error : AppColors.cyan, width: 1.5),
            ),
            suffixIcon: trailing,
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Text(
            errorText!,
            style: AppTextStyles.bodyM.copyWith(color: AppColors.error, fontSize: 13),
          ),
        ],
      ],
    );
  }
}
