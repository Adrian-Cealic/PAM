import 'package:equatable/equatable.dart';

class HomeData extends Equatable {
  const HomeData({
    required this.header,
    required this.learnedToday,
    required this.myCourses,
    required this.learningPrompt,
    required this.learningPlan,
    required this.meetup,
  });

  final UserHeader header;
  final DailyProgress learnedToday;
  final SectionLink myCourses;
  final LearningPrompt learningPrompt;
  final LearningPlan learningPlan;
  final Meetup meetup;

  @override
  List<Object?> get props => [header, learnedToday, myCourses, learningPrompt, learningPlan, meetup];
}

class UserHeader extends Equatable {
  const UserHeader({
    required this.greeting,
    required this.subtitle,
    required this.avatarUrl,
    required this.hasUnreadNotifications,
    required this.notificationIconUrl,
  });

  final String greeting;
  final String subtitle;
  final String avatarUrl;
  final bool hasUnreadNotifications;
  final String notificationIconUrl;

  @override
  List<Object?> get props => [greeting, subtitle, avatarUrl, hasUnreadNotifications, notificationIconUrl];
}

class DailyProgress extends Equatable {
  const DailyProgress({
    required this.title,
    required this.learnedMinutes,
    required this.goalMinutes,
    required this.formatted,
    required this.progress,
  });

  final String title;
  final int learnedMinutes;
  final int goalMinutes;
  final String formatted;
  final double progress;

  @override
  List<Object?> get props => [title, learnedMinutes, goalMinutes, formatted, progress];
}

class SectionLink extends Equatable {
  const SectionLink({required this.title, required this.actionLabel});

  final String title;
  final String actionLabel;

  @override
  List<Object?> get props => [title, actionLabel];
}

class LearningPrompt extends Equatable {
  const LearningPrompt({required this.title, required this.actionLabel, required this.imageUrl});

  final String title;
  final String actionLabel;
  final String imageUrl;

  @override
  List<Object?> get props => [title, actionLabel, imageUrl];
}

class LearningPlan extends Equatable {
  const LearningPlan({required this.title, required this.items});

  final String title;
  final List<LearningPlanItem> items;

  @override
  List<Object?> get props => [title, items];
}

class LearningPlanItem extends Equatable {
  const LearningPlanItem({
    required this.id,
    required this.title,
    required this.completed,
    required this.total,
    required this.progress,
    required this.progressIconUrl,
  });

  final String id;
  final String title;
  final int completed;
  final int total;
  final double progress;
  final String progressIconUrl;

  @override
  List<Object?> get props => [id, title, completed, total, progress, progressIconUrl];
}

class Meetup extends Equatable {
  const Meetup({required this.title, required this.subtitle, required this.imageUrl});

  final String title;
  final String subtitle;
  final String imageUrl;

  @override
  List<Object?> get props => [title, subtitle, imageUrl];
}
