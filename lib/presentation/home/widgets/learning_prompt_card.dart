import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../domain/entities/home.dart';

class LearningPromptCard extends StatelessWidget {
  const LearningPromptCard({super.key, required this.prompt, required this.onStart});

  final LearningPrompt prompt;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.primarySoft,
      elevated: false,
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: 164,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 11,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      prompt.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyStrong.copyWith(fontSize: 16, fontWeight: FontWeight.w600, height: 1.3),
                    ),
                    PrimaryButton(label: prompt.actionLabel, onPressed: onStart, compact: true),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: AppNetworkImage(
                prompt.imageUrl,
                borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
