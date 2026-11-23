import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'app.dart';
import 'data/datasources/learning_local_data_source.dart';
import 'data/repositories/favorites_repository_impl.dart';
import 'data/repositories/learning_repository_impl.dart';

const _dataAsset = String.fromEnvironment('DATA_ASSET', defaultValue: LearningLocalDataSource.defaultAssetPath);

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final dataSource = LearningLocalDataSource(assetPath: _dataAsset);

  runApp(
    LearningApp(
      learningRepository: LearningRepositoryImpl(dataSource),
      favoritesRepository: FavoritesRepositoryImpl(),
      httpClient: http.Client(),
    ),
  );
}
