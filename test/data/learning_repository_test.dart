import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:learning_app/core/errors/data_exception.dart';
import 'package:learning_app/core/network/api_config.dart';
import 'package:learning_app/data/datasources/learning_remote_data_source.dart';
import 'package:learning_app/data/repositories/learning_repository_impl.dart';

LearningRepositoryImpl repositoryFor(MockClient client) {
  return LearningRepositoryImpl(LearningRemoteDataSource(client: client, config: const ApiConfig()));
}

MockClient serving({required Object? feed, required Object? details}) {
  return MockClient((request) async {
    final body = switch (request.url.path) {
      '/lab2026/v4/feed' => feed,
      '/lab2026/v4/feed/details' => details,
      _ => null,
    };
    if (body == null) return http.Response('not found', 404);
    return http.Response.bytes(utf8.encode(body is String ? body : jsonEncode(body)), 200);
  });
}

void main() {
  final fixture = jsonDecode(File('test/fixtures/lab_v4.json').readAsStringSync()) as Map<String, dynamic>;
  final rawHome = fixture['homePage'] as Map<String, dynamic>;
  final rawDetails = fixture['courseOverviewPage'] as Map<String, dynamic>;

  group('oracle: parsed entities match the raw JSON field by field', () {
    late final repository = repositoryFor(serving(feed: rawHome, details: rawDetails));

    test('course and every lesson', () async {
      final overview = await repository.getCourseOverview();
      final rawCourse = rawDetails['course'] as Map<String, dynamic>;
      final rawLessons = (rawCourse['lessons'] as List).cast<Map<String, dynamic>>();

      expect(overview.screenTitle, rawDetails['navigation']['title']);
      expect(overview.course.title, rawCourse['title']);
      expect(overview.course.duration, rawCourse['duration']);
      expect(overview.course.lessonCount, rawCourse['lessonCount']);
      expect(overview.course.rating, rawCourse['rating']);
      expect(overview.course.hero.videoCount, rawCourse['hero']['videoCount']);
      expect(overview.course.description, rawCourse['description']['text']);
      expect(overview.course.selectedTabId, rawCourse['tabs']['selected']);
      expect(
        [for (final t in overview.course.tabs) t.id],
        [for (final t in rawCourse['tabs']['items'] as List) t['id']],
      );
      expect(overview.price.label, rawDetails['actions']['price']['label']);
      expect(overview.enroll.enabled, rawDetails['actions']['enroll']['enabled']);

      expect(overview.course.lessons.length, rawLessons.length);
      final byId = {for (final l in overview.course.lessons) l.id: l};
      expect(byId.length, rawLessons.length, reason: 'lesson ids must be unique');
      for (final raw in rawLessons) {
        final parsed = byId[raw['id']]!;
        expect(parsed.title, raw['title']);
        expect(parsed.duration, raw['duration']);
        expect(parsed.durationSeconds, raw['durationSeconds']);
        expect(parsed.locked, raw['locked']);
        expect(parsed.completed, raw['completed']);
        expect(parsed.playIconUrl, raw['playIconUrl']);
        expect(parsed.arrowIconUrl, raw['arrowIconUrl']);
      }
    });

    test('home page and every learning plan item', () async {
      final home = await repository.getHomeData();
      final rawItems = (rawHome['learningPlan']['items'] as List).cast<Map<String, dynamic>>();

      expect(home.header.greeting, rawHome['header']['greeting']);
      expect(home.header.subtitle, rawHome['header']['subtitle']);
      expect(home.header.hasUnreadNotifications, rawHome['header']['notification']['hasUnread']);
      expect(home.learnedToday.learnedMinutes, rawHome['learnedToday']['learnedMinutes']);
      expect(home.learnedToday.goalMinutes, rawHome['learnedToday']['goalMinutes']);
      expect(home.learnedToday.progress, rawHome['learnedToday']['progress']);
      expect(home.myCourses.actionLabel, rawHome['myCourses']['actionLabel']);
      expect(home.learningPrompt.actionLabel, rawHome['learningPrompt']['actionLabel']);
      expect(home.meetup.subtitle, rawHome['meetup']['subtitle']);

      expect(home.learningPlan.items.length, rawItems.length);
      for (var i = 0; i < rawItems.length; i++) {
        expect(home.learningPlan.items[i].id, rawItems[i]['id']);
        expect(home.learningPlan.items[i].completed, rawItems[i]['completed']);
        expect(home.learningPlan.items[i].total, rawItems[i]['total']);
        expect(home.learningPlan.items[i].progress, rawItems[i]['progress']);
      }
    });
  });

  group('errors', () {
    test('HTTP error becomes DataException', () {
      final client = MockClient((_) async => http.Response('boom', 500));
      expect(repositoryFor(client).getHomeData(), throwsA(isA<DataException>()));
    });

    test('malformed JSON becomes DataException', () {
      expect(repositoryFor(serving(feed: '{"header": ', details: '{}')).getHomeData(), throwsA(isA<DataException>()));
    });

    test('empty object (missing fields) becomes DataException', () {
      expect(repositoryFor(serving(feed: '{}', details: '{}')).getCourseOverview(), throwsA(isA<DataException>()));
    });

    test('wrong field type becomes DataException', () {
      final broken = jsonDecode(jsonEncode(rawDetails)) as Map<String, dynamic>;
      broken['course']['lessons'][0]['durationSeconds'] = '268';
      expect(repositoryFor(serving(feed: rawHome, details: broken)).getCourseOverview(), throwsA(isA<DataException>()));
    });

    test('a failed call does not poison the next one', () async {
      var calls = 0;
      final client = MockClient((request) async {
        calls++;
        if (calls == 1) return http.Response('boom', 503);
        return http.Response.bytes(utf8.encode(jsonEncode(rawHome)), 200);
      });
      final repository = repositoryFor(client);
      await expectLater(repository.getHomeData(), throwsA(isA<DataException>()));
      final home = await repository.getHomeData();
      expect(home.header.greeting, rawHome['header']['greeting']);
      expect(calls, 2);
    });
  });
}
