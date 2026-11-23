import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_progress_bar.dart';
import '../../../core/widgets/network_svg_icon.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/state_views.dart';
import '../../../domain/entities/home.dart';

class LearningPlanCard extends StatelessWidget {
  const LearningPlanCard({super.key, required this.plan});

  final LearningPlan plan;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(plan.title),
        AppCard(
          child: plan.items.isEmpty
              ? const EmptyView(
                  title: 'No plan yet',
                  message: 'Courses you start will appear here.',
                  icon: Icons.event_note_outlined,
                )
              : Column(
                  children: [
                    for (var i = 0; i < plan.items.length; i++) ...[
                      if (i > 0) const SizedBox(height: 16),
                      LearningPlanTile(item: plan.items[i]),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

class LearningPlanTile extends StatelessWidget {
  const LearningPlanTile({super.key, required this.item});

  final LearningPlanItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NetworkSvgIcon(item.progressIconUrl, size: 26, fallback: Icons.timelapse),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.bodyStrong),
              const SizedBox(height: 6),
              AppProgressBar(value: item.progress, height: 5),
            ],
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 52,
          child: Text.rich(
            textAlign: TextAlign.end,
            TextSpan(
              children: [
                TextSpan(text: '${item.completed}', style: AppTextStyles.bodyStrong),
                TextSpan(
                  text: '/${item.total}',
                  style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
