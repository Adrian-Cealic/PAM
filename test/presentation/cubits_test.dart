import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/domain/entities/lesson_query.dart';
import 'package:learning_app/presentation/course/cubit/course_cubit.dart';
import 'package:learning_app/presentation/course/cubit/course_state.dart';
import 'package:learning_app/presentation/home/cubit/home_cubit.dart';
import 'package:learning_app/presentation/home/cubit/home_state.dart';

import '../helpers/fakes.dart';

CourseCubit courseCubit({FakeLearningRepository? learning, InMemoryFavoritesRepository? favorites}) => CourseCubit(
  learningRepository: learning ?? FakeLearningRepository(),
  favoritesRepository: favorites ?? InMemoryFavoritesRepository(),
);

List<String> visibleIds(CourseState s) => [for (final l in s.visibleLessons) l.id];

void main() {
  group('HomeCubit', () {
    blocTest<HomeCubit, HomeState>(
      'emits loading then success',
      build: () => HomeCubit(FakeLearningRepository()),
      act: (cubit) => cubit.load(),
      expect: () => [
        const HomeState(status: HomeStatus.loading),
        const HomeState(status: HomeStatus.success, data: sampleHome),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'emits error, then recovers on retry',
      build: () => HomeCubit(FakeLearningRepository(failuresBeforeSuccess: 1)),
      act: (cubit) async {
        await cubit.load();
        await cubit.load();
      },
      expect: () => [
        const HomeState(status: HomeStatus.loading),
        isA<HomeState>()
            .having((s) => s.status, 'status', HomeStatus.error)
            .having((s) => s.errorMessage, 'msg', isNotEmpty),
        const HomeState(status: HomeStatus.loading),
        const HomeState(status: HomeStatus.success, data: sampleHome),
      ],
    );
  });

  group('CourseCubit', () {
    blocTest<CourseCubit, CourseState>(
      'load emits loading then success with all lessons and stored favorites',
      build: () => courseCubit(favorites: InMemoryFavoritesRepository({'l3'})),
      act: (cubit) => cubit.load(),
      expect: () => [
        const CourseState(status: CourseStatus.loading),
        isA<CourseState>()
            .having((s) => s.status, 'status', CourseStatus.success)
            .having(visibleIds, 'visible', ['l1', 'l2', 'l3', 'l4'])
            .having((s) => s.favoriteIds, 'favorites', {'l3'}),
      ],
    );

    blocTest<CourseCubit, CourseState>(
      'course without lessons is Empty',
      build: () => courseCubit(
        learning: FakeLearningRepository(overview: sampleOverview(lessons: [])),
      ),
      act: (cubit) => cubit.load(),
      skip: 1,
      expect: () => [isA<CourseState>().having((s) => s.status, 'status', CourseStatus.empty)],
    );

    blocTest<CourseCubit, CourseState>(
      'load failure emits error',
      build: () => courseCubit(learning: FakeLearningRepository(failuresBeforeSuccess: 1)),
      act: (cubit) => cubit.load(),
      skip: 1,
      expect: () => [isA<CourseState>().having((s) => s.status, 'status', CourseStatus.error)],
    );

    blocTest<CourseCubit, CourseState>(
      'search without matches is Empty, reset restores Success',
      build: courseCubit,
      act: (cubit) async {
        await cubit.load();
        cubit.search('angular');
        cubit.resetQuery();
      },
      skip: 2,
      expect: () => [
        isA<CourseState>().having((s) => s.status, 'status', CourseStatus.empty).having(visibleIds, 'visible', isEmpty),
        isA<CourseState>()
            .having((s) => s.status, 'status', CourseStatus.success)
            .having((s) => s.query, 'query', const LessonQuery()),
      ],
    );

    blocTest<CourseCubit, CourseState>(
      'filter and sort update visible lessons',
      build: courseCubit,
      act: (cubit) async {
        await cubit.load();
        cubit.setFilter(LessonFilter.available);
        cubit.setSort(LessonSort.durationDesc);
      },
      skip: 2,
      expect: () => [
        isA<CourseState>().having(visibleIds, 'visible', ['l1', 'l2', 'l3']),
        isA<CourseState>().having(visibleIds, 'visible', ['l3', 'l2', 'l1']),
      ],
    );

    test('toggleFavorite persists and refreshes the favorites filter', () async {
      final favorites = InMemoryFavoritesRepository();
      final cubit = courseCubit(favorites: favorites);
      await cubit.load();
      cubit.setFilter(LessonFilter.favorites);
      expect(cubit.state.status, CourseStatus.empty);

      await cubit.toggleFavorite('l2');
      expect(favorites.favorites, {'l2'});
      expect(visibleIds(cubit.state), ['l2']);
      expect(cubit.state.status, CourseStatus.success);

      await cubit.toggleFavorite('l2');
      expect(favorites.favorites, isEmpty);
      expect(cubit.state.status, CourseStatus.empty);
      await cubit.close();
    });

    test('favorite failure keeps data and exposes a one-off message', () async {
      final favorites = InMemoryFavoritesRepository()..failOnToggle = true;
      final cubit = courseCubit(favorites: favorites);
      await cubit.load();
      await cubit.toggleFavorite('l1');
      expect(cubit.state.status, CourseStatus.success);
      expect(cubit.state.errorMessage, 'Could not update favorites.');
      expect(cubit.state.favoriteIds, isEmpty);
      await cubit.close();
    });

    test('enroll and tab selection', () async {
      final cubit = courseCubit();
      await cubit.load();
      cubit.selectTab('description');
      cubit.enroll();
      expect(cubit.state.selectedTabId, 'description');
      expect(cubit.state.enrolled, isTrue);
      await cubit.close();
    });
  });
}
