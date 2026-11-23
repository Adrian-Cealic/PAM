import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/network_svg_icon.dart';
import '../../../domain/entities/course.dart';
import 'favorite_button.dart';

class LessonTile extends StatelessWidget {
  const LessonTile({
    super.key,
    required this.lesson,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  final Lesson lesson;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    final titleColor = lesson.locked ? AppColors.textMuted : AppColors.ink;

    return AppCard(
      key: Key('lesson_${lesson.id}'),
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
      child: Row(
        children: [
          NetworkSvgIcon(lesson.playIconUrl, size: 44, fallback: Icons.play_circle_outline),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyStrong.copyWith(color: titleColor),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(lesson.duration, style: AppTextStyles.caption),
                    if (lesson.locked) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.lock_outline, size: 14, color: AppColors.textMuted),
                      const SizedBox(width: 2),
                      const Flexible(
                        child: Text('Locked', overflow: TextOverflow.ellipsis, style: AppTextStyles.caption),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          FavoriteButton(isFavorite: isFavorite, onPressed: onFavoriteToggle, keyId: lesson.id),
          NetworkSvgIcon(lesson.arrowIconUrl, size: 28, fallback: Icons.chevron_right),
        ],
      ),
    );
  }
}
