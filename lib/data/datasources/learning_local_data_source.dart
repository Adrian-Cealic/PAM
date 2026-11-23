import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../core/errors/data_exception.dart';

class LearningLocalDataSource {
  LearningLocalDataSource({
    AssetBundle? bundle,
    this.assetPath = defaultAssetPath,
    this.simulatedLatency = const Duration(milliseconds: 700),
  }) : _bundle = bundle ?? rootBundle;

  static const defaultAssetPath = 'assets/data/lab_v4.json';

  final AssetBundle _bundle;
  final String assetPath;
  final Duration simulatedLatency;

  Future<Map<String, dynamic>>? _cache;

  Future<Map<String, dynamic>> loadSection(String key) async {
    final document = await _loadDocument();
    final section = document[key];
    if (section is! Map<String, dynamic>) {
      throw DataException('Section "$key" is missing from the data file.');
    }
    return section;
  }

  Future<Map<String, dynamic>> _loadDocument() {
    return _cache ??= _readAndDecode().catchError((Object error) {
      _cache = null;
      throw error;
    });
  }

  Future<Map<String, dynamic>> _readAndDecode() async {
    await Future<void>.delayed(simulatedLatency);

    final String raw;
    try {
      raw = await _bundle.loadString(assetPath, cache: false);
    } catch (error) {
      throw DataException('Could not read "$assetPath".', error);
    }

    try {
      final decoded = await compute(_decodeJson, raw);
      debugPrint(const JsonEncoder.withIndent('  ').convert(decoded));
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Root element must be a JSON object.');
      }
      return decoded;
    } on FormatException catch (error) {
      throw DataException('The data file is not valid JSON.', error);
    }
  }
}

Object? _decodeJson(String raw) => jsonDecode(raw);
