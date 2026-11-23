import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/state_views.dart';
import '../../../domain/entities/home.dart';
import '../../course/screens/course_overview_screen.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/home_header.dart';
import '../widgets/learned_today_card.dart';
import '../widgets/learning_plan_card.dart';
import '../widgets/learning_prompt_card.dart';
import '../widgets/meetup_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return switch (state.status) {
            HomeStatus.loading => const LoadingView(),
            HomeStatus.error => SafeArea(
              child: ErrorView(
                message: state.errorMessage ?? 'Unknown error.',
                onRetry: context.read<HomeCubit>().load,
              ),
            ),
            HomeStatus.success => _HomeContent(data: state.data!),
          };
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.data});

  final HomeData data;

  static const _overlap = 56.0;

  void _openCourse(BuildContext context) => Navigator.of(context).push(CourseOverviewScreen.route());

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: context.read<HomeCubit>().load,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          Stack(
            children: [
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: _overlap,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 24),
                        child: HomeHeader(header: data.header),
                      ),
                    ),
                    LearnedTodayCard(
                      progress: data.learnedToday,
                      link: data.myCourses,
                      onLinkTap: () => _openCourse(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LearningPromptCard(prompt: data.learningPrompt, onStart: () => _openCourse(context)),
                const SizedBox(height: 24),
                LearningPlanCard(plan: data.learningPlan),
                const SizedBox(height: 24),
                MeetupCard(meetup: data.meetup),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
