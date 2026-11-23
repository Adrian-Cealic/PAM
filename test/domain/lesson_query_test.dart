import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/domain/entities/lesson_query.dart';

import '../helpers/fakes.dart';

List<String> ids(Iterable lessons) => [for (final l in lessons) l.id as String];

void main() {
  group('LessonQuery.apply', () {
    test('default query keeps every lesson in course order', () {
      expect(ids(const LessonQuery().apply(sampleLessons, {})), ['l1', 'l2', 'l3', 'l4']);
    });

    test('search is case-insensitive and trims whitespace', () {
      expect(ids(const LessonQuery(search: '  CREATE ').apply(sampleLessons, {})), ['l3']);
      expect(ids(const LessonQuery(search: 'react').apply(sampleLessons, {})).length, 4);
      expect(const LessonQuery(search: 'vue').apply(sampleLessons, {}), isEmpty);
    });

    test('available and locked filters partition the list without losing lessons', () {
      final available = const LessonQuery(filter: LessonFilter.available).apply(sampleLessons, {});
      final locked = const LessonQuery(filter: LessonFilter.locked).apply(sampleLessons, {});
      expect(ids(locked), ['l4']);
      expect({...ids(available), ...ids(locked)}, {...ids(sampleLessons)});
      expect(available.length + locked.length, sampleLessons.length);
    });

    test('favorites filter keeps only favorite ids', () {
      expect(ids(const LessonQuery(filter: LessonFilter.favorites).apply(sampleLessons, {'l2', 'l4'})), ['l2', 'l4']);
      expect(const LessonQuery(filter: LessonFilter.favorites).apply(sampleLessons, {}), isEmpty);
    });

    test('sorts by title and duration in both directions', () {
      expect(ids(const LessonQuery(sort: LessonSort.titleAsc).apply(sampleLessons, {})), ['l4', 'l3', 'l1', 'l2']);
      expect(ids(const LessonQuery(sort: LessonSort.titleDesc).apply(sampleLessons, {})), ['l2', 'l1', 'l3', 'l4']);
      expect(ids(const LessonQuery(sort: LessonSort.durationAsc).apply(sampleLessons, {})), ['l1', 'l2', 'l4', 'l3']);
      expect(ids(const LessonQuery(sort: LessonSort.durationDesc).apply(sampleLessons, {})), ['l3', 'l4', 'l2', 'l1']);
    });

    test('search, filter and sort combine', () {
      const query = LessonQuery(search: 'react', filter: LessonFilter.available, sort: LessonSort.durationDesc);
      expect(ids(query.apply(sampleLessons, {})), ['l3', 'l2', 'l1']);
    });

    test('does not mutate the source list', () {
      final source = [...sampleLessons];
      const LessonQuery(sort: LessonSort.titleAsc).apply(source, {});
      expect(ids(source), ['l1', 'l2', 'l3', 'l4']);
    });
  });
}
