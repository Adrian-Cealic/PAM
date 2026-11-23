import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:learning_app/app.dart';

import '../helpers/fakes.dart';

final svgClient = MockClient(
  (_) async => http.Response(
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/></svg>',
    200,
  ),
);

Future<void> pumpApp(
  WidgetTester tester, {
  FakeLearningRepository? learning,
  InMemoryFavoritesRepository? favorites,
  double width = 390,
  double height = 1800,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    LearningApp(
      learningRepository: learning ?? FakeLearningRepository(),
      favoritesRepository: favorites ?? InMemoryFavoritesRepository(),
      httpClient: svgClient,
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> openCourse(WidgetTester tester) async {
  await tester.tap(find.text('Get Started'));
  await tester.pumpAndSettle();
}

Finder lessonTiles() => find.byWidgetPredicate(
  (w) => w.key is ValueKey<String> && (w.key! as ValueKey<String>).value.startsWith('lesson_l'),
);

void main() {
  testWidgets('home shows Loading, then data from the repository', (tester) async {
    final learning = FakeLearningRepository()..gate = Completer<void>();
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      LearningApp(
        learningRepository: learning,
        favoritesRepository: InMemoryFavoritesRepository(),
        httpClient: svgClient,
      ),
    );
    await tester.pump();
    expect(find.byKey(const Key('loading_view')), findsOneWidget);

    learning.gate!.complete();
    await tester.pumpAndSettle();
    expect(find.text('Hi, Kristin'), findsOneWidget);
    expect(find.text('Learning Plan'), findsOneWidget);
    expect(find.text('Packaging Design'), findsOneWidget);
    expect(find.byKey(const Key('unread_badge')), findsOneWidget);
  });

  testWidgets('home Error state retries and recovers', (tester) async {
    await pumpApp(tester, learning: FakeLearningRepository(failuresBeforeSuccess: 1));
    expect(find.byKey(const Key('error_view')), findsOneWidget);

    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('error_view')), findsNothing);
    expect(find.text('Hi, Kristin'), findsOneWidget);
  });

  testWidgets('course: search to Empty, reset, filter, sort', (tester) async {
    await pumpApp(tester);
    await openCourse(tester);
    expect(find.text('React Front To back'), findsOneWidget);
    expect(lessonTiles(), findsNWidgets(4));

    await tester.enterText(find.byKey(const Key('search_field')), 'angular');
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('empty_view')), findsOneWidget);
    expect(lessonTiles(), findsNothing);

    await tester.tap(find.text('Reset filters'));
    await tester.pumpAndSettle();
    expect(lessonTiles(), findsNWidgets(4));
    expect(tester.widget<TextField>(find.byKey(const Key('search_field'))).controller!.text, isEmpty);

    await tester.tap(find.byKey(const Key('filter_locked')));
    await tester.pumpAndSettle();
    expect(lessonTiles(), findsOneWidget);
    expect(find.text('Build React'), findsOneWidget);

    await tester.tap(find.byKey(const Key('filter_all')));
    await tester.tap(find.byKey(const Key('sort_menu')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('sort_durationDesc')));
    await tester.pumpAndSettle();
    final order = tester.widgetList(lessonTiles()).map((w) => (w.key! as ValueKey<String>).value).toList();
    expect(order, ['lesson_l3', 'lesson_l4', 'lesson_l2', 'lesson_l1']);
  });

  testWidgets('course: favorites toggle, favorites filter, persistence', (tester) async {
    final favorites = InMemoryFavoritesRepository();
    await pumpApp(tester, favorites: favorites);
    await openCourse(tester);

    await tester.tap(find.byKey(const Key('favorite_l2')));
    await tester.pumpAndSettle();
    expect(favorites.favorites, {'l2'});

    await tester.tap(find.byKey(const Key('filter_favorites')));
    await tester.pumpAndSettle();
    expect(lessonTiles(), findsOneWidget);
    expect(find.text('Understanding React'), findsOneWidget);

    await tester.tap(find.byKey(const Key('favorite_l2')));
    await tester.pumpAndSettle();
    expect(favorites.favorites, isEmpty);
    expect(find.byKey(const Key('empty_view')), findsOneWidget);
  });

  testWidgets('course: Description tab is Empty for empty text', (tester) async {
    await pumpApp(tester);
    await openCourse(tester);
    await tester.tap(find.text('Description'));
    await tester.pumpAndSettle();
    expect(find.text('No description yet'), findsOneWidget);
  });

  testWidgets('course Error state retries', (tester) async {
    final learning = FakeLearningRepository();
    await pumpApp(tester, learning: learning);
    learning.failuresBeforeSuccess = 1;
    await openCourse(tester);
    expect(find.byKey(const Key('error_view')), findsOneWidget);

    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(lessonTiles(), findsNWidgets(4));
  });

  testWidgets('details: open, favorite syncs back to list, next lesson, enroll', (tester) async {
    await pumpApp(tester);
    await openCourse(tester);

    await tester.tap(find.text('Introduction to React'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('lesson_title')), findsOneWidget);
    expect(find.text('Lesson 1 of 4 · React Front To back'), findsOneWidget);

    await tester.tap(find.byKey(const Key('favorite_details_l1')));
    await tester.pumpAndSettle();
    expect(find.text('Favorite'), findsOneWidget);

    await tester.tap(find.byKey(const Key('next_lesson')));
    await tester.pumpAndSettle();
    expect(find.text('Lesson 2 of 4 · React Front To back'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    final heart = tester.widget<Icon>(
      find.descendant(of: find.byKey(const Key('favorite_l1')), matching: find.byType(Icon)),
    );
    expect(heart.icon, Icons.favorite);

    await tester.tap(find.byKey(const Key('enroll_button')));
    await tester.pumpAndSettle();
    expect(find.text('Enrolled'), findsOneWidget);
  });

  testWidgets('details: locked lesson cannot continue', (tester) async {
    await pumpApp(tester);
    await openCourse(tester);
    await tester.scrollUntilVisible(find.text('Build React'), 200, scrollable: find.byType(Scrollable).last);
    await tester.tap(find.text('Build React'));
    await tester.pumpAndSettle();
    expect(find.text('This lesson is locked'), findsOneWidget);
  });

  group('no layout overflow', () {
    for (final width in [320.0, 360.0, 390.0, 402.0, 768.0]) {
      testWidgets('at ${width.toInt()}px on every screen', (tester) async {
        await pumpApp(tester, width: width, height: 700);
        await tester.drag(find.byType(Scrollable).first, const Offset(0, -2000));
        await tester.pumpAndSettle();

        await tester.drag(find.byType(Scrollable).first, const Offset(0, 2000));
        await tester.pumpAndSettle();
        await openCourse(tester);
        await tester.drag(find.byType(Scrollable).last, const Offset(0, -2000));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('filter_favorites')));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('empty_view')), findsOneWidget);
        await tester.tap(find.byKey(const Key('filter_all')));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Introduction to React'));
        await tester.pumpAndSettle();
        await tester.drag(find.byType(Scrollable).last, const Offset(0, -2000));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  });
}
