import 'package:equatable/equatable.dart';

class CourseOverview extends Equatable {
  const CourseOverview({
    required this.screenTitle,
    required this.backIconUrl,
    required this.course,
    required this.price,
    required this.enroll,
    required this.icons,
  });

  final String screenTitle;
  final String backIconUrl;
  final Course course;
  final CoursePrice price;
  final EnrollAction enroll;
  final CourseIcons icons;

  @override
  List<Object?> get props => [screenTitle, backIconUrl, course, price, enroll, icons];
}

class Course extends Equatable {
  const Course({
    required this.id,
    required this.title,
    required this.duration,
    required this.durationMinutes,
    required this.lessonCount,
    required this.rating,
    required this.hero,
    required this.tabs,
    required this.selectedTabId,
    required this.lessons,
    required this.description,
  });

  final String id;
  final String title;
  final String duration;
  final int durationMinutes;
  final int lessonCount;
  final double rating;
  final CourseHero hero;
  final List<CourseTab> tabs;
  final String selectedTabId;
  final List<Lesson> lessons;
  final String description;

  @override
  List<Object?> get props => [
    id,
    title,
    duration,
    durationMinutes,
    lessonCount,
    rating,
    hero,
    tabs,
    selectedTabId,
    lessons,
    description,
  ];
}

class CourseHero extends Equatable {
  const CourseHero({
    required this.label,
    required this.imageUrl,
    required this.playIconUrl,
    required this.videoCount,
    required this.classCount,
  });

  final String label;
  final String imageUrl;
  final String playIconUrl;
  final int videoCount;
  final int classCount;

  @override
  List<Object?> get props => [label, imageUrl, playIconUrl, videoCount, classCount];
}

class CourseTab extends Equatable {
  const CourseTab({required this.id, required this.label});

  final String id;
  final String label;

  @override
  List<Object?> get props => [id, label];
}

class Lesson extends Equatable {
  const Lesson({
    required this.id,
    required this.title,
    required this.duration,
    required this.durationSeconds,
    required this.completed,
    required this.locked,
    required this.playIconUrl,
    required this.arrowIconUrl,
  });

  final String id;
  final String title;
  final String duration;
  final int durationSeconds;
  final bool completed;
  final bool locked;
  final String playIconUrl;
  final String arrowIconUrl;

  @override
  List<Object?> get props => [id, title, duration, durationSeconds, completed, locked, playIconUrl, arrowIconUrl];
}

class CoursePrice extends Equatable {
  const CoursePrice({required this.label, required this.amount, required this.currency});

  final String label;
  final double amount;
  final String currency;

  @override
  List<Object?> get props => [label, amount, currency];
}

class EnrollAction extends Equatable {
  const EnrollAction({required this.label, required this.enabled});

  final String label;
  final bool enabled;

  @override
  List<Object?> get props => [label, enabled];
}

class CourseIcons extends Equatable {
  const CourseIcons({required this.durationIconUrl, required this.lessonsIconUrl, required this.ratingIconUrl});

  final String durationIconUrl;
  final String lessonsIconUrl;
  final String ratingIconUrl;

  @override
  List<Object?> get props => [durationIconUrl, lessonsIconUrl, ratingIconUrl];
}
