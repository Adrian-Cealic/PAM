import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/icon_label.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/state_views.dart';
import '../../../domain/entities/course.dart';
import '../cubit/course_cubit.dart';
import '../cubit/course_state.dart';
import '../widgets/course_hero_card.dart';
import '../widgets/favorite_button.dart';

class LessonDetailsScreen extends StatelessWidget {
  const LessonDetailsScreen({super.key, required this.lessonId});

  final String lessonId;

  static Route<void> route(CourseCubit cubit, String lessonId) {
    return MaterialPageRoute(
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: LessonDetailsScreen(lessonId: lessonId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseCubit, CourseState>(
      builder: (context, state) {
        final lesson = state.lessonById(lessonId);
        final overview = state.overview;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Lesson'),
            actions: [
              if (lesson != null)
                FavoriteButton(
                  keyId: 'details_${lesson.id}',
                  isFavorite: state.isFavorite(lesson.id),
                  onPressed: () => context.read<CourseCubit>().toggleFavorite(lesson.id),
                ),
              const SizedBox(width: 8),
            ],
          ),
          body: lesson == null || overview == null
              ? const EmptyView(
                  title: 'Lesson not found',
                  message: 'This lesson is no longer part of the course.',
                  icon: Icons.help_outline,
                )
              : _LessonContent(lesson: lesson, overview: overview, isFavorite: state.isFavorite(lesson.id)),
        );
      },
    );
  }
}

class _LessonContent extends StatelessWidget {
  const _LessonContent({required this.lesson, required this.overview, required this.isFavorite});

  final Lesson lesson;
  final CourseOverview overview;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    final course = overview.course;
    final lessons = course.lessons;
    final position = lessons.indexWhere((item) => item.id == lesson.id);
    final next = position + 1 < lessons.length ? lessons[position + 1] : null;
    final cubit = context.read<CourseCubit>();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        CourseHeroCard(hero: course.hero, showStats: false),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _StatusChip(lesson: lesson),
            if (isFavorite) const _Chip(label: 'Favorite', icon: Icons.favorite, color: AppColors.favorite),
          ],
        ),
        const SizedBox(height: 12),
        Text(lesson.title, key: const Key('lesson_title'), style: AppTextStyles.headline),
        const SizedBox(height: 8),
        Text('Lesson ${position + 1} of ${lessons.length} · ${course.title}', style: AppTextStyles.body),
        const SizedBox(height: 20),
        AppCard(
          child: Wrap(
            spacing: 20,
            runSpacing: 10,
            children: [
              IconLabel(iconUrl: overview.icons.durationIconUrl, label: lesson.duration),
              IconLabel(iconUrl: overview.icons.lessonsIconUrl, label: '${course.lessonCount} Lessons'),
              IconLabel(iconUrl: overview.icons.ratingIconUrl, label: course.rating.toStringAsFixed(1)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        if (lesson.locked)
          const PrimaryButton(label: 'This lesson is locked', icon: Icons.lock_outline, onPressed: null)
        else if (next != null)
          PrimaryButton(
            key: const Key('next_lesson'),
            label: 'Next: ${next.title}',
            icon: Icons.skip_next,
            onPressed: () => Navigator.of(context).pushReplacement(LessonDetailsScreen.route(cubit, next.id)),
          )
        else
          PrimaryButton(label: 'Back to course', onPressed: () => Navigator.of(context).pop()),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    if (lesson.completed) {
      return const _Chip(label: 'Completed', icon: Icons.check_circle_outline, color: AppColors.success);
    }
    if (lesson.locked) {
      return const _Chip(label: 'Locked', icon: Icons.lock_outline, color: AppColors.textMuted);
    }
    return const _Chip(label: 'Available', icon: Icons.play_circle_outline, color: AppColors.primary);
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.icon, required this.color});

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
