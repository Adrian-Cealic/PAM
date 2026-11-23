import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_progress_bar.dart';
import '../../../domain/entities/home.dart';

class LearnedTodayCard extends StatelessWidget {
  const LearnedTodayCard({super.key, required this.progress, required this.link, required this.onLinkTap});

  final DailyProgress progress;
  final SectionLink link;
  final VoidCallback onLinkTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(progress.title, style: AppTextStyles.body)),
              TextButton(
                onPressed: onLinkTap,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: const Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textStyle: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
                ),
                child: Text(link.actionLabel),
              ),
            ],
          ),
          Semantics(
            label: progress.formatted,
            excludeSemantics: true,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '${progress.learnedMinutes}min', style: AppTextStyles.title),
                  TextSpan(text: ' / ${progress.goalMinutes}min', style: AppTextStyles.body),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppProgressBar(value: progress.progress),
        ],
      ),
    );
  }
}
