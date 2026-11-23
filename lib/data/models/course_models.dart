import '../../domain/entities/course.dart';
import 'json_helpers.dart';

class CourseOverviewModel extends CourseOverview {
  const CourseOverviewModel({
    required super.screenTitle,
    required super.backIconUrl,
    required super.course,
    required super.price,
    required super.enroll,
    required super.icons,
  });

  factory CourseOverviewModel.fromJson(Map<String, dynamic> json) {
    final navigation = json.object('navigation');
    final actions = json.object('actions');
    return CourseOverviewModel(
      screenTitle: navigation['title'] as String,
      backIconUrl: navigation['backIconUrl'] as String,
      course: CourseModel.fromJson(json.object('course')),
      price: CoursePriceModel.fromJson(actions.object('price')),
      enroll: EnrollActionModel.fromJson(actions.object('enroll')),
      icons: CourseIconsModel.fromJson(json.object('uiIcons')),
    );
  }
}

class CourseModel extends Course {
  const CourseModel({
    required super.id,
    required super.title,
    required super.duration,
    required super.durationMinutes,
    required super.lessonCount,
    required super.rating,
    required super.hero,
    required super.tabs,
    required super.selectedTabId,
    required super.lessons,
    required super.description,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    final tabs = json.object('tabs');
    return CourseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      duration: json['duration'] as String,
      durationMinutes: json['durationMinutes'] as int,
      lessonCount: json['lessonCount'] as int,
      rating: json.decimal('rating'),
      hero: CourseHeroModel.fromJson(json.object('hero')),
      tabs: tabs.objectList('items').map(CourseTabModel.fromJson).toList(growable: false),
      selectedTabId: tabs['selected'] as String,
      lessons: json.objectList('lessons').map(LessonModel.fromJson).toList(growable: false),
      description: json.object('description')['text'] as String,
    );
  }
}

class CourseHeroModel extends CourseHero {
  const CourseHeroModel({
    required super.label,
    required super.imageUrl,
    required super.playIconUrl,
    required super.videoCount,
    required super.classCount,
  });

  factory CourseHeroModel.fromJson(Map<String, dynamic> json) {
    return CourseHeroModel(
      label: json['label'] as String,
      imageUrl: json['imageUrl'] as String,
      playIconUrl: json['playIconUrl'] as String,
      videoCount: json['videoCount'] as int,
      classCount: json['classCount'] as int,
    );
  }
}

class CourseTabModel extends CourseTab {
  const CourseTabModel({required super.id, required super.label});

  factory CourseTabModel.fromJson(Map<String, dynamic> json) {
    return CourseTabModel(id: json['id'] as String, label: json['label'] as String);
  }
}

class LessonModel extends Lesson {
  const LessonModel({
    required super.id,
    required super.title,
    required super.duration,
    required super.durationSeconds,
    required super.completed,
    required super.locked,
    required super.playIconUrl,
    required super.arrowIconUrl,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String,
      title: json['title'] as String,
      duration: json['duration'] as String,
      durationSeconds: json['durationSeconds'] as int,
      completed: json['completed'] as bool,
      locked: json['locked'] as bool,
      playIconUrl: json['playIconUrl'] as String,
      arrowIconUrl: json['arrowIconUrl'] as String,
    );
  }
}

class CoursePriceModel extends CoursePrice {
  const CoursePriceModel({required super.label, required super.amount, required super.currency});

  factory CoursePriceModel.fromJson(Map<String, dynamic> json) {
    return CoursePriceModel(
      label: json['label'] as String,
      amount: json.decimal('amount'),
      currency: json['currency'] as String,
    );
  }
}

class EnrollActionModel extends EnrollAction {
  const EnrollActionModel({required super.label, required super.enabled});

  factory EnrollActionModel.fromJson(Map<String, dynamic> json) {
    return EnrollActionModel(label: json['label'] as String, enabled: json['enabled'] as bool);
  }
}

class CourseIconsModel extends CourseIcons {
  const CourseIconsModel({required super.durationIconUrl, required super.lessonsIconUrl, required super.ratingIconUrl});

  factory CourseIconsModel.fromJson(Map<String, dynamic> json) {
    return CourseIconsModel(
      durationIconUrl: json['durationIconUrl'] as String,
      lessonsIconUrl: json['lessonsIconUrl'] as String,
      ratingIconUrl: json['ratingIconUrl'] as String,
    );
  }
}
