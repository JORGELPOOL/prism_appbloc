import 'package:flutter/material.dart';

import '../../../core/mock/mock_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class AdminClientsScreen extends StatelessWidget {
  const AdminClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final clients = MockData.clientsList;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Clients', style: AppTextStyles.pageTitle),
                const Spacer(),
                const _AddClientButton(),
              ],
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border1))),
              child: Row(
                children: [
                  Expanded(flex: 3, child: Text('CLIENT', style: AppTextStyles.dataLabel)),
                  Expanded(flex: 2, child: Text('PACKAGE', style: AppTextStyles.dataLabel)),
                  Expanded(flex: 2, child: Text('POOL BALANCE', style: AppTextStyles.dataLabel)),
                  Expanded(flex: 2, child: Text('CLIPS THIS MONTH', style: AppTextStyles.dataLabel)),
                  Expanded(flex: 1, child: Text('STATUS', style: AppTextStyles.dataLabel)),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: clients.length,
                separatorBuilder: (_, __) => Container(height: 1, color: AppColors.border1),
                itemBuilder: (context, i) {
                  final c = clients[i];
                  final balance = c['pool_balance'] as double;
                  final isLow = balance < 5000;

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    color: AppColors.bgVoid,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c['name'],
                                style: AppTextStyles.bodyL.copyWith(color: AppColors.textWhite, fontWeight: FontWeight.w600),
                              ),
                              Text(c['business'], style: AppTextStyles.bodyS),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(border: Border.all(color: AppColors.border2)),
                            child: Text(c['package'], style: AppTextStyles.dataLabel.copyWith(color: AppColors.textSilver)),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Rs ${balance.toStringAsFixed(0)}',
                            style: AppTextStyles.bodyL.copyWith(
                              color: isLow
                                  ? AppColors.error
                                  : balance < 15000
                                      ? AppColors.warning
                                      : AppColors.cyan,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Expanded(flex: 2, child: Text('${c['clips_this_month']} clips', style: AppTextStyles.bodyM)),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            color: AppColors.cyan.withValues(alpha: 0.1),
                            child: Text('ACTIVE', style: AppTextStyles.dataLabel.copyWith(color: AppColors.cyan)),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddClientButton extends StatelessWidget {
  const _AddClientButton();

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          color: AppColors.cyan,
          child: Text('+ Add New Client', style: AppTextStyles.btnPrimary),
        ),
      );
}
