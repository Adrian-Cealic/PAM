import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:learning_app/core/errors/data_exception.dart';
import 'package:learning_app/core/network/api_config.dart';
import 'package:learning_app/data/datasources/learning_remote_data_source.dart';

LearningRemoteDataSource dataSource(MockClient client, {ApiConfig config = const ApiConfig()}) {
  return LearningRemoteDataSource(client: client, config: config);
}

Matcher dataExceptionWith(String text) => isA<DataException>().having((e) => e.message, 'message', contains(text));

void main() {
  test('requests the v4 feed and feed/details endpoints with GET and Accept json', () async {
    final requests = <http.BaseRequest>[];
    final client = MockClient((request) async {
      requests.add(request);
      return http.Response('{}', 200);
    });

    await dataSource(client).fetchFeed();
    await dataSource(client).fetchFeedDetails();

    expect(requests.map((r) => r.method), ['GET', 'GET']);
    expect(requests.map((r) => r.url.toString()), [
      'https://test-api-jlbn.onrender.com/lab2026/v4/feed',
      'https://test-api-jlbn.onrender.com/lab2026/v4/feed/details',
    ]);
    expect(requests.first.headers['Accept'], 'application/json');
  });

  test('base url and version are configurable', () async {
    late Uri requested;
    final client = MockClient((request) async {
      requested = request.url;
      return http.Response('{}', 200);
    });

    await dataSource(client, config: const ApiConfig(baseUrl: 'https://example.com/api', version: 'v2')).fetchFeed();

    expect(requested.toString(), 'https://example.com/api/v2/feed');
  });

  test('decodes UTF-8 even when the response has no charset', () async {
    final client = MockClient(
      (_) async => http.Response.bytes(
        utf8.encode('{"subtitle":"Let’s start learning"}'),
        200,
        headers: {'content-type': 'application/json'},
      ),
    );

    final json = await dataSource(client).fetchFeed();

    expect(json['subtitle'], 'Let’s start learning');
  });

  group('failures become DataException with a readable message', () {
    test('non-200 status', () {
      final client = MockClient((_) async => http.Response('', 404));
      expect(dataSource(client).fetchFeed(), throwsA(dataExceptionWith('404')));
    });

    test('invalid JSON', () {
      final client = MockClient((_) async => http.Response('<html>', 200));
      expect(dataSource(client).fetchFeed(), throwsA(dataExceptionWith('not valid JSON')));
    });

    test('JSON that is not an object', () {
      final client = MockClient((_) async => http.Response('[1, 2]', 200));
      expect(dataSource(client).fetchFeedDetails(), throwsA(dataExceptionWith('not valid JSON')));
    });

    test('no connection', () {
      final client = MockClient((_) async => throw http.ClientException('Failed host lookup'));
      expect(dataSource(client).fetchFeed(), throwsA(dataExceptionWith('internet connection')));
    });

    test('timeout', () {
      final client = MockClient((_) => Completer<http.Response>().future);
      final source = dataSource(client, config: const ApiConfig(timeout: Duration(milliseconds: 20)));
      expect(source.fetchFeed(), throwsA(dataExceptionWith('too long')));
    });
  });
}
