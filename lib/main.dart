import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'app.dart';
import 'core/network/api_config.dart';
import 'data/datasources/learning_remote_data_source.dart';
import 'data/repositories/favorites_repository_impl.dart';
import 'data/repositories/learning_repository_impl.dart';

const _apiConfig = ApiConfig(
  baseUrl: String.fromEnvironment('API_BASE_URL', defaultValue: ApiConfig.defaultBaseUrl),
  version: String.fromEnvironment('API_VERSION', defaultValue: ApiConfig.defaultVersion),
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final httpClient = http.Client();

  runApp(
    LearningApp(
      learningRepository: LearningRepositoryImpl(LearningRemoteDataSource(client: httpClient, config: _apiConfig)),
      favoritesRepository: FavoritesRepositoryImpl(),
      httpClient: httpClient,
    ),
  );
}
