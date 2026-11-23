import '../../domain/entities/home.dart';
import 'json_helpers.dart';

class HomeDataModel extends HomeData {
  const HomeDataModel({
    required super.header,
    required super.learnedToday,
    required super.myCourses,
    required super.learningPrompt,
    required super.learningPlan,
    required super.meetup,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    return HomeDataModel(
      header: UserHeaderModel.fromJson(json.object('header')),
      learnedToday: DailyProgressModel.fromJson(json.object('learnedToday')),
      myCourses: SectionLinkModel.fromJson(json.object('myCourses')),
      learningPrompt: LearningPromptModel.fromJson(json.object('learningPrompt')),
      learningPlan: LearningPlanModel.fromJson(json.object('learningPlan')),
      meetup: MeetupModel.fromJson(json.object('meetup')),
    );
  }
}

class UserHeaderModel extends UserHeader {
  const UserHeaderModel({
    required super.greeting,
    required super.subtitle,
    required super.avatarUrl,
    required super.hasUnreadNotifications,
    required super.notificationIconUrl,
  });

  factory UserHeaderModel.fromJson(Map<String, dynamic> json) {
    final notification = json.object('notification');
    return UserHeaderModel(
      greeting: json['greeting'] as String,
      subtitle: json['subtitle'] as String,
      avatarUrl: json['avatarUrl'] as String,
      hasUnreadNotifications: notification['hasUnread'] as bool,
      notificationIconUrl: notification['iconUrl'] as String,
    );
  }
}

class DailyProgressModel extends DailyProgress {
  const DailyProgressModel({
    required super.title,
    required super.learnedMinutes,
    required super.goalMinutes,
    required super.formatted,
    required super.progress,
  });

  factory DailyProgressModel.fromJson(Map<String, dynamic> json) {
    return DailyProgressModel(
      title: json['title'] as String,
      learnedMinutes: json['learnedMinutes'] as int,
      goalMinutes: json['goalMinutes'] as int,
      formatted: json['formatted'] as String,
      progress: json.decimal('progress'),
    );
  }
}

class SectionLinkModel extends SectionLink {
  const SectionLinkModel({required super.title, required super.actionLabel});

  factory SectionLinkModel.fromJson(Map<String, dynamic> json) {
    return SectionLinkModel(title: json['title'] as String, actionLabel: json['actionLabel'] as String);
  }
}

class LearningPromptModel extends LearningPrompt {
  const LearningPromptModel({required super.title, required super.actionLabel, required super.imageUrl});

  factory LearningPromptModel.fromJson(Map<String, dynamic> json) {
    return LearningPromptModel(
      title: json['title'] as String,
      actionLabel: json['actionLabel'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }
}

class LearningPlanModel extends LearningPlan {
  const LearningPlanModel({required super.title, required super.items});

  factory LearningPlanModel.fromJson(Map<String, dynamic> json) {
    return LearningPlanModel(
      title: json['title'] as String,
      items: json.objectList('items').map(LearningPlanItemModel.fromJson).toList(growable: false),
    );
  }
}

class LearningPlanItemModel extends LearningPlanItem {
  const LearningPlanItemModel({
    required super.id,
    required super.title,
    required super.completed,
    required super.total,
    required super.progress,
    required super.progressIconUrl,
  });

  factory LearningPlanItemModel.fromJson(Map<String, dynamic> json) {
    return LearningPlanItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      completed: json['completed'] as int,
      total: json['total'] as int,
      progress: json.decimal('progress'),
      progressIconUrl: json['progressIconUrl'] as String,
    );
  }
}

class MeetupModel extends Meetup {
  const MeetupModel({required super.title, required super.subtitle, required super.imageUrl});

  factory MeetupModel.fromJson(Map<String, dynamic> json) {
    return MeetupModel(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }
}
