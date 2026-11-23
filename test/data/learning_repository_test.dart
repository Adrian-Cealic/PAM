import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/core/errors/data_exception.dart';
import 'package:learning_app/data/datasources/learning_local_data_source.dart';
import 'package:learning_app/data/repositories/learning_repository_impl.dart';

class DiskAssetBundle extends CachingAssetBundle {
  DiskAssetBundle(this.files);

  final Map<String, String> files;
  int reads = 0;

  @override
  Future<ByteData> load(String key) async {
    reads++;
    final content = files[key];
    if (content == null) throw FlutterError('Unable to load asset: "$key".');
    return ByteData.sublistView(utf8.encode(content));
  }
}

LearningRepositoryImpl repositoryFor(DiskAssetBundle bundle) {
  return LearningRepositoryImpl(LearningLocalDataSource(bundle: bundle, simulatedLatency: Duration.zero));
}

void main() {
  const asset = LearningLocalDataSource.defaultAssetPath;
  final bundledJson = File(asset).readAsStringSync();
  final original = jsonDecode(File('../lab v4.json').readAsStringSync()) as Map<String, dynamic>;

  test('bundled asset is byte-identical to the lab data file', () {
    expect(bundledJson, File('../lab v4.json').readAsStringSync());
  });

  group('oracle: parsed entities match the raw JSON field by field', () {
    late final repository = repositoryFor(DiskAssetBundle({asset: bundledJson}));

    test('course and every lesson', () async {
      final overview = await repository.getCourseOverview();
      final rawPage = original['courseOverviewPage'] as Map<String, dynamic>;
      final rawCourse = rawPage['course'] as Map<String, dynamic>;
      final rawLessons = (rawCourse['lessons'] as List).cast<Map<String, dynamic>>();

      expect(overview.screenTitle, rawPage['navigation']['title']);
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
      expect(overview.price.label, rawPage['actions']['price']['label']);
      expect(overview.enroll.enabled, rawPage['actions']['enroll']['enabled']);

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
      final raw = original['homePage'] as Map<String, dynamic>;
      final rawItems = (raw['learningPlan']['items'] as List).cast<Map<String, dynamic>>();

      expect(home.header.greeting, raw['header']['greeting']);
      expect(home.header.hasUnreadNotifications, raw['header']['notification']['hasUnread']);
      expect(home.learnedToday.learnedMinutes, raw['learnedToday']['learnedMinutes']);
      expect(home.learnedToday.goalMinutes, raw['learnedToday']['goalMinutes']);
      expect(home.learnedToday.progress, raw['learnedToday']['progress']);
      expect(home.myCourses.actionLabel, raw['myCourses']['actionLabel']);
      expect(home.learningPrompt.actionLabel, raw['learningPrompt']['actionLabel']);
      expect(home.meetup.subtitle, raw['meetup']['subtitle']);

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
    test('missing asset becomes DataException', () {
      expect(repositoryFor(DiskAssetBundle({})).getHomeData(), throwsA(isA<DataException>()));
    });

    test('malformed JSON becomes DataException', () {
      expect(repositoryFor(DiskAssetBundle({asset: '{"homePage": '})).getHomeData(), throwsA(isA<DataException>()));
    });

    test('missing section becomes DataException', () {
      expect(repositoryFor(DiskAssetBundle({asset: '{}'})).getCourseOverview(), throwsA(isA<DataException>()));
    });

    test('wrong field type becomes DataException', () {
      final broken = jsonDecode(bundledJson) as Map<String, dynamic>;
      broken['courseOverviewPage']['course']['lessons'][0]['durationSeconds'] = '268';
      expect(
        repositoryFor(DiskAssetBundle({asset: jsonEncode(broken)})).getCourseOverview(),
        throwsA(isA<DataException>()),
      );
    });

    test('document is read once on success and re-read after a failure', () async {
      final bundle = DiskAssetBundle({});
      final repository = repositoryFor(bundle);
      await expectLater(repository.getHomeData(), throwsA(isA<DataException>()));

      bundle.files[asset] = bundledJson;
      await repository.getHomeData();
      await repository.getCourseOverview();
      expect(bundle.reads, 2);
    });
  });
}
