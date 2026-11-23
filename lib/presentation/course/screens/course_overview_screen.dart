import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/network_svg_icon.dart';
import '../../../core/widgets/segmented_tabs.dart';
import '../../../core/widgets/state_views.dart';
import '../../../domain/entities/course.dart';
import '../cubit/course_cubit.dart';
import '../cubit/course_state.dart';
import '../widgets/course_hero_card.dart';
import '../widgets/course_info.dart';
import '../widgets/enroll_bar.dart';
import '../widgets/lesson_tile.dart';
import '../widgets/lesson_toolbar.dart';
import 'lesson_details_screen.dart';

const _lessonsTabId = 'lessons';
const _horizontalPadding = EdgeInsets.symmetric(horizontal: 20);

class CourseOverviewScreen extends StatelessWidget {
  const CourseOverviewScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) =>
            CourseCubit(learningRepository: context.read(), favoritesRepository: context.read())..load(),
        child: const CourseOverviewScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CourseCubit, CourseState>(
      listenWhen: (previous, current) => current.status != CourseStatus.error && current.errorMessage != null,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
      },
      builder: (context, state) {
        final overview = state.overview;
        return Scaffold(
          appBar: AppBar(
            title: Text(overview?.screenTitle ?? ''),
            leading: overview == null
                ? const BackButton()
                : IconButton(
                    tooltip: 'Back',
                    icon: NetworkSvgIcon(overview.backIconUrl, size: 26, fallback: Icons.arrow_back),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
          ),
          body: switch (state.status) {
            CourseStatus.loading => const LoadingView(),
            CourseStatus.error => ErrorView(
              message: state.errorMessage ?? 'Unknown error.',
              onRetry: context.read<CourseCubit>().load,
            ),
            CourseStatus.success || CourseStatus.empty => _CourseContent(state: state),
          },
          bottomNavigationBar: overview == null
              ? null
              : EnrollBar(
                  price: overview.price,
                  enroll: overview.enroll,
                  enrolled: state.enrolled,
                  onEnroll: () => _enroll(context, overview.course),
                ),
        );
      },
    );
  }

  void _enroll(BuildContext context, Course course) {
    context.read<CourseCubit>().enroll();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('You are enrolled in "${course.title}".')));
  }
}

class _CourseContent extends StatelessWidget {
  const _CourseContent({required this.state});

  final CourseState state;

  void _openLesson(BuildContext context, Lesson lesson) {
    Navigator.of(context).push(LessonDetailsScreen.route(context.read<CourseCubit>(), lesson.id));
  }

  Lesson? _firstAvailableLesson(Course course) {
    for (final lesson in course.lessons) {
      if (!lesson.locked) return lesson;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CourseCubit>();
    final overview = state.overview!;
    final course = overview.course;
    final tabs = course.tabs;
    final selectedIndex = tabs.indexWhere((tab) => tab.id == state.selectedTabId).clamp(0, tabs.length - 1);
    final firstLesson = _firstAvailableLesson(course);
    final showLessons = state.selectedTabId == _lessonsTabId;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: _horizontalPadding.copyWith(top: 8),
          sliver: SliverList.list(
            children: [
              CourseHeroCard(
                hero: course.hero,
                onPlay: firstLesson == null ? null : () => _openLesson(context, firstLesson),
              ),
              const SizedBox(height: 20),
              CourseInfo(course: course, icons: overview.icons),
              const SizedBox(height: 20),
              SegmentedTabs(
                labels: [for (final tab in tabs) tab.label],
                selectedIndex: selectedIndex,
                onSelected: (index) => cubit.selectTab(tabs[index].id),
              ),
              const SizedBox(height: 16),
              if (showLessons) const LessonToolbar(),
            ],
          ),
        ),
        if (!showLessons)
          SliverFillRemaining(hasScrollBody: false, child: _DescriptionTab(text: course.description))
        else if (state.status == CourseStatus.empty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyView(
              title: 'No lessons found',
              message: course.lessons.isEmpty
                  ? 'This course has no lessons yet.'
                  : 'Nothing matches your search or filter.',
              icon: Icons.search_off,
              actionLabel: state.query.isDefault ? null : 'Reset filters',
              onAction: state.query.isDefault ? null : cubit.resetQuery,
            ),
          )
        else
          SliverPadding(
            padding: _horizontalPadding.copyWith(top: 12, bottom: 24),
            sliver: SliverList.separated(
              itemCount: state.visibleLessons.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final lesson = state.visibleLessons[index];
                return LessonTile(
                  lesson: lesson,
                  isFavorite: state.isFavorite(lesson.id),
                  onTap: () => _openLesson(context, lesson),
                  onFavoriteToggle: () => cubit.toggleFavorite(lesson.id),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _DescriptionTab extends StatelessWidget {
  const _DescriptionTab({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    if (text.trim().isEmpty) {
      return const EmptyView(
        title: 'No description yet',
        message: 'The author has not added a description for this course.',
        icon: Icons.description_outlined,
      );
    }
    return Padding(
      padding: _horizontalPadding.copyWith(top: 8, bottom: 24),
      child: Text(text, style: AppTextStyles.body),
    );
  }
}
