import 'package:flutter/material.dart';

import '../../../core/mock/mock_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class AdminMessagesScreen extends StatefulWidget {
  const AdminMessagesScreen({super.key});

  @override
  State<AdminMessagesScreen> createState() => _AdminMessagesScreenState();
}

class _AdminMessagesScreenState extends State<AdminMessagesScreen> {
  String? _selectedClientId;
  final _msg = TextEditingController();

  @override
  void dispose() {
    _msg.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clients = MockData.messagesList;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Row(
        children: [
          Container(
            width: 300,
            decoration: const BoxDecoration(
              color: AppColors.bgVoid,
              border: Border(right: BorderSide(color: AppColors.border1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('Messages', style: AppTextStyles.sectionHead),
                ),
                Container(height: 1, color: AppColors.border1),
                Expanded(
                  child: ListView.separated(
                    itemCount: clients.length,
                    separatorBuilder: (_, __) => Container(height: 1, color: AppColors.border1),
                    itemBuilder: (_, i) {
                      final c = clients[i];
                      final isSelected = _selectedClientId == c['client_id'];
                      return GestureDetector(
                        onTap: () => setState(() => _selectedClientId = c['client_id']),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          color: isSelected ? AppColors.bgSurface : Colors.transparent,
                          child: Row(
                            children: [
                              if (c['unread'] as bool)
                                Container(
                                  width: 6,
                                  height: 6,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: const BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle),
                                ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      c['client_name'],
                                      style: AppTextStyles.bodyM.copyWith(color: AppColors.textWhite, fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(c['last_message'], style: AppTextStyles.bodyS, maxLines: 1, overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                              Text(c['timestamp'], style: AppTextStyles.timestamp),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _selectedClientId == null
                ? Center(child: Text('Select a conversation', style: AppTextStyles.bodyM))
                : Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border1))),
                        child: Row(
                          children: [
                            Text('Abhinabh Parida', style: AppTextStyles.sectionHead.copyWith(fontSize: 16)),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(border: Border.all(color: AppColors.border2)),
                              child: Text('Scale', style: AppTextStyles.dataLabel.copyWith(color: AppColors.gold)),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: MockData.threadMessages.length,
                          itemBuilder: (_, i) {
                            final m = MockData.threadMessages[i];
                            final isAdmin = m['sender'] == 'admin';
                            return Align(
                              alignment: isAdmin ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                constraints: const BoxConstraints(maxWidth: 480),
                                color: isAdmin ? AppColors.cyan : AppColors.bgSurface,
                                child: Column(
                                  crossAxisAlignment: isAdmin ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      m['message'],
                                      style: AppTextStyles.bodyM.copyWith(color: isAdmin ? AppColors.bgPrimary : AppColors.textWhite),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      m['time'],
                                      style: AppTextStyles.timestamp.copyWith(
                                        color: isAdmin ? AppColors.bgPrimary.withValues(alpha: 0.6) : AppColors.textDim,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.border1))),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _msg,
                                style: AppTextStyles.bodyM.copyWith(color: AppColors.textWhite),
                                decoration: InputDecoration(
                                  hintText: 'Type a message...',
                                  hintStyle: AppTextStyles.bodyM.copyWith(color: AppColors.textDim),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                color: AppColors.cyan,
                                child: const Icon(Icons.send, color: Color(0xFF050508), size: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
