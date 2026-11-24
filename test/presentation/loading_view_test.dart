import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/core/widgets/state_views.dart';

void main() {
  testWidgets('shows the slow-server hint only after the delay', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: LoadingView(slowAfter: Duration(seconds: 5)))));

    expect(find.byKey(const Key('loading_view')), findsOneWidget);
    expect(find.byKey(const Key('loading_slow_hint')), findsNothing);

    await tester.pump(const Duration(seconds: 4));
    expect(find.byKey(const Key('loading_slow_hint')), findsNothing);

    await tester.pump(const Duration(seconds: 2));
    expect(find.byKey(const Key('loading_slow_hint')), findsOneWidget);
  });

  testWidgets('leaves no pending timer when removed before the delay', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: LoadingView())));
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SizedBox())));
  });
}
