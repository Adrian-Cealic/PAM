import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/featured_plan_card.dart';
import '../widgets/filter_pill.dart';
import '../widgets/program_card.dart';
import '../widgets/progress_card.dart';
import '../widgets/section_header.dart';
import '../widgets/status_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const double _gutter = 24;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.white,
      child: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StatusBar(),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: _gutter),
                child: _Greeting(
                  date: 'Friday, 20 May',
                  greeting: 'Good Morning',
                ),
              ),
              const SizedBox(height: 32),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: _gutter),
                child: ProgressCard(
                  label: 'Today\u2019s Challenge',
                  title: 'Running',
                  progressLabel: '15/20',
                ),
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: _gutter),
                child: SectionHeader(
                  title: 'Featured Plan',
                  actionLabel: 'See All',
                ),
              ),
              const SizedBox(height: 16),
              const _FeaturedPlanRow(),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: _gutter),
                child: SectionHeader(
                  title: 'Workout Programs',
                  actionLabel: 'See All',
                ),
              ),
              const SizedBox(height: 16),
              const _FilterRow(),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: _gutter),
                child: _ProgramGrid(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.date, required this.greeting});

  final String date;
  final String greeting;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(date, style: AppTextStyles.smallRegular()),
            const SizedBox(height: 4),
            Text(greeting, style: AppTextStyles.h6Bold()),
          ],
        ),
        SvgPicture.asset('assets/icons/bell_frame.svg', width: 48, height: 48),
      ],
    );
  }
}

class _FeaturedPlanRow extends StatelessWidget {
  const _FeaturedPlanRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: FeaturedPlanCard.height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: HomeScreen._gutter),
        itemCount: 2,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (_, _) => const FeaturedPlanCard(
          title: 'Massive Upper Body',
          duration: '5 week',
          frequency: '4x/week',
          imageAsset: 'assets/images/featured_upper_body.jpg',
        ),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow();

  static const _labels = ['All Type', 'Pilates', 'Cardio', 'Boxing', 'Yoga'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: HomeScreen._gutter),
      child: Row(
        children: [
          for (var i = 0; i < _labels.length; i++) ...[
            if (i > 0) const SizedBox(width: 12),
            FilterPill(label: _labels[i], selected: i == 0),
          ],
        ],
      ),
    );
  }
}

class _ProgramGrid extends StatelessWidget {
  const _ProgramGrid();

  /// Sub aceasta latime de continut cele doua coloane devin prea inguste
  /// pentru randul de statistici, asa ca machetele se stivuiesc.
  static const double _twoColumnMinWidth = 292;

  static const _yoga = ProgramCard(
    title: 'Yoga',
    calories: '210 kcl',
    minutes: '120 min',
    imageAsset: 'assets/images/program_yoga.jpg',
  );

  static const _arm = ProgramCard(
    title: 'Arm\nStrengthening',
    calories: '210 kcl',
    minutes: '120 min',
    imageAsset: 'assets/images/program_arm.jpg',
    imageAlignment: Alignment(0.35, 0),
    isPro: true,
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < _twoColumnMinWidth) {
          return const Column(children: [_yoga, SizedBox(height: 16), _arm]);
        }

        return const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _yoga),
            SizedBox(width: 16),
            Expanded(child: _arm),
          ],
        );
      },
    );
  }
}
