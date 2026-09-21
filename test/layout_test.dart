import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_mockup/screens/fitness_screen.dart';
import 'package:fitness_mockup/screens/home_screen.dart';

void main() {
  const widths = <double>[1440, 768, 402, 390, 375, 360, 320];

  final screens = <String, Widget>{
    'HomeScreen': const HomeScreen(),
    'FitnessScreen': const FitnessScreen(),
  };

  for (final entry in screens.entries) {
    for (final width in widths) {
      testWidgets('${entry.key} nu are overflow la ${width.toInt()}px', (
        tester,
      ) async {
        tester.view.physicalSize = Size(width * 2, 812 * 2);
        tester.view.devicePixelRatio = 2;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: entry.value),
            theme: ThemeData(fontFamily: 'PlusJakartaSans'),
          ),
        );
        await tester.pump();

        expect(tester.takeException(), isNull);
      });
    }
  }
}
