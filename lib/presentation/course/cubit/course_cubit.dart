import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors/data_exception.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/entities/lesson_query.dart';
import '../../../domain/repositories/favorites_repository.dart';
import '../../../domain/repositories/learning_repository.dart';
import 'course_state.dart';

class CourseCubit extends Cubit<CourseState> {
  CourseCubit({required this._learningRepository, required this._favoritesRepository}) : super(const CourseState());

  final LearningRepository _learningRepository;
  final FavoritesRepository _favoritesRepository;

  Future<void> load() async {
    emit(const CourseState(status: CourseStatus.loading));
    try {
      final results = await Future.wait<Object>([
        _learningRepository.getCourseOverview(),
        _favoritesRepository.loadFavorites(),
      ]);
      final overview = results[0] as CourseOverview;
      final favorites = results[1] as Set<String>;
      if (isClosed) return;

      emit(
        _withVisibleLessons(
          CourseState(overview: overview, favoriteIds: favorites, selectedTabId: overview.course.selectedTabId),
        ),
      );
    } on DataException catch (error) {
      if (isClosed) return;
      emit(CourseState(status: CourseStatus.error, errorMessage: error.message));
    }
  }

  void search(String text) => _updateQuery(state.query.copyWith(search: text));

  void setFilter(LessonFilter filter) => _updateQuery(state.query.copyWith(filter: filter));

  void setSort(LessonSort sort) => _updateQuery(state.query.copyWith(sort: sort));

  void resetQuery() => _updateQuery(const LessonQuery());

  void selectTab(String tabId) {
    if (!state.hasData || tabId == state.selectedTabId) return;
    emit(state.copyWith(selectedTabId: tabId));
  }

  void enroll() {
    if (!state.hasData || state.enrolled || !state.overview!.enroll.enabled) return;
    emit(state.copyWith(enrolled: true));
  }

  Future<void> toggleFavorite(String lessonId) async {
    if (!state.hasData) return;
    try {
      final favorites = await _favoritesRepository.toggleFavorite(lessonId);
      if (isClosed) return;
      emit(_withVisibleLessons(state.copyWith(favoriteIds: favorites)));
    } on DataException catch (error) {
      if (isClosed) return;
      emit(state.copyWith(errorMessage: error.message));
    }
  }

  void _updateQuery(LessonQuery query) {
    if (!state.hasData || query == state.query) return;
    emit(_withVisibleLessons(state.copyWith(query: query)));
  }

  CourseState _withVisibleLessons(CourseState base) {
    final lessons = base.overview!.course.lessons;
    final visible = base.query.apply(lessons, base.favoriteIds);
    return base.copyWith(status: visible.isEmpty ? CourseStatus.empty : CourseStatus.success, visibleLessons: visible);
  }
}
