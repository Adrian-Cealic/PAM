import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  const families = {
    'PlusJakartaSans': [
      'assets/fonts/PlusJakartaSans-400.ttf',
      'assets/fonts/PlusJakartaSans-500.ttf',
      'assets/fonts/PlusJakartaSans-600.ttf',
      'assets/fonts/PlusJakartaSans-700.ttf',
    ],
    'Inter': ['assets/fonts/Inter-500.ttf'],
  };

  for (final entry in families.entries) {
    final loader = FontLoader(entry.key);
    for (final path in entry.value) {
      loader.addFont(
        File(path).readAsBytes().then((bytes) => ByteData.sublistView(bytes)),
      );
    }
    await loader.load();
  }

  await testMain();
}
