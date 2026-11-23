import 'package:equatable/equatable.dart';

import '../../../domain/entities/course.dart';
import '../../../domain/entities/lesson_query.dart';

enum CourseStatus { loading, success, empty, error }

class CourseState extends Equatable {
  const CourseState({
    this.status = CourseStatus.loading,
    this.overview,
    this.query = const LessonQuery(),
    this.favoriteIds = const {},
    this.visibleLessons = const [],
    this.selectedTabId = 'lessons',
    this.enrolled = false,
    this.errorMessage,
  });

  final CourseStatus status;
  final CourseOverview? overview;
  final LessonQuery query;
  final Set<String> favoriteIds;
  final List<Lesson> visibleLessons;
  final String selectedTabId;
  final bool enrolled;
  final String? errorMessage;

  bool get hasData => overview != null;

  bool isFavorite(String lessonId) => favoriteIds.contains(lessonId);

  Lesson? lessonById(String id) {
    for (final lesson in overview?.course.lessons ?? const <Lesson>[]) {
      if (lesson.id == id) return lesson;
    }
    return null;
  }

  CourseState copyWith({
    CourseStatus? status,
    CourseOverview? overview,
    LessonQuery? query,
    Set<String>? favoriteIds,
    List<Lesson>? visibleLessons,
    String? selectedTabId,
    bool? enrolled,
    String? errorMessage,
  }) {
    return CourseState(
      status: status ?? this.status,
      overview: overview ?? this.overview,
      query: query ?? this.query,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      visibleLessons: visibleLessons ?? this.visibleLessons,
      selectedTabId: selectedTabId ?? this.selectedTabId,
      enrolled: enrolled ?? this.enrolled,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    overview,
    query,
    favoriteIds,
    visibleLessons,
    selectedTabId,
    enrolled,
    errorMessage,
  ];
}
