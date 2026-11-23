import 'package:equatable/equatable.dart';

import 'course.dart';

enum LessonFilter { all, available, locked, favorites }

enum LessonSort { defaultOrder, titleAsc, titleDesc, durationAsc, durationDesc }

class LessonQuery extends Equatable {
  const LessonQuery({this.search = '', this.filter = LessonFilter.all, this.sort = LessonSort.defaultOrder});

  final String search;
  final LessonFilter filter;
  final LessonSort sort;

  bool get isDefault => search.trim().isEmpty && filter == LessonFilter.all && sort == LessonSort.defaultOrder;

  LessonQuery copyWith({String? search, LessonFilter? filter, LessonSort? sort}) {
    return LessonQuery(search: search ?? this.search, filter: filter ?? this.filter, sort: sort ?? this.sort);
  }

  List<Lesson> apply(List<Lesson> lessons, Set<String> favoriteIds) {
    final term = search.trim().toLowerCase();
    final result = lessons
        .where((lesson) => term.isEmpty || lesson.title.toLowerCase().contains(term))
        .where((lesson) => _matchesFilter(lesson, favoriteIds))
        .toList();

    final comparator = _comparator();
    if (comparator != null) result.sort(comparator);
    return result;
  }

  bool _matchesFilter(Lesson lesson, Set<String> favoriteIds) {
    return switch (filter) {
      LessonFilter.all => true,
      LessonFilter.available => !lesson.locked,
      LessonFilter.locked => lesson.locked,
      LessonFilter.favorites => favoriteIds.contains(lesson.id),
    };
  }

  int Function(Lesson, Lesson)? _comparator() {
    return switch (sort) {
      LessonSort.defaultOrder => null,
      LessonSort.titleAsc => (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
      LessonSort.titleDesc => (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()),
      LessonSort.durationAsc => (a, b) => a.durationSeconds.compareTo(b.durationSeconds),
      LessonSort.durationDesc => (a, b) => b.durationSeconds.compareTo(a.durationSeconds),
    };
  }

  @override
  List<Object?> get props => [search, filter, sort];
}
