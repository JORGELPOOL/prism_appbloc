import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class PrismLoader extends StatelessWidget {
  const PrismLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 28,
        width: 28,
        child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.cyan),
      ),
    );
  }
}
