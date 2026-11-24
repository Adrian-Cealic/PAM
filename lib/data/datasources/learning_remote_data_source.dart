import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../core/errors/data_exception.dart';
import '../../core/network/api_config.dart';
import 'learning_data_source.dart';

class LearningRemoteDataSource implements LearningDataSource {
  const LearningRemoteDataSource({required this._client, this.config = const ApiConfig()});

  final http.Client _client;
  final ApiConfig config;

  @override
  Future<Map<String, dynamic>> fetchFeed() => _getJson('feed');

  @override
  Future<Map<String, dynamic>> fetchFeedDetails() => _getJson('feed/details');

  Future<Map<String, dynamic>> _getJson(String path) async {
    final response = await _send(config.endpoint(path));
    if (response.statusCode != 200) {
      throw DataException('The server answered with status ${response.statusCode}.');
    }
    return _decode(response.bodyBytes);
  }

  Future<http.Response> _send(Uri uri) async {
    try {
      return await _client.get(uri, headers: const {'Accept': 'application/json'}).timeout(config.timeout);
    } on TimeoutException catch (error) {
      throw DataException('The server took too long to respond.', error);
    } on http.ClientException catch (error) {
      throw DataException('Could not reach the server. Check your internet connection.', error);
    }
  }

  Future<Map<String, dynamic>> _decode(Uint8List bytes) async {
    try {
      final decoded = await compute(_decodeUtf8Json, bytes);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Root element must be a JSON object.');
      }
      return decoded;
    } on FormatException catch (error) {
      throw DataException('The server sent data that is not valid JSON.', error);
    }
  }
}

Object? _decodeUtf8Json(Uint8List bytes) => jsonDecode(utf8.decode(bytes));
