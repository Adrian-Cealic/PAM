import '../../domain/entities/lesson_query.dart';

extension LessonFilterLabel on LessonFilter {
  String get label => switch (this) {
    LessonFilter.all => 'All',
    LessonFilter.available => 'Available',
    LessonFilter.locked => 'Locked',
    LessonFilter.favorites => 'Favorites',
  };
}

extension LessonSortLabel on LessonSort {
  String get label => switch (this) {
    LessonSort.defaultOrder => 'Course order',
    LessonSort.titleAsc => 'Title A-Z',
    LessonSort.titleDesc => 'Title Z-A',
    LessonSort.durationAsc => 'Shortest first',
    LessonSort.durationDesc => 'Longest first',
  };
}
