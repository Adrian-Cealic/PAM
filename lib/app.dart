import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'core/network/http_client_scope.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'domain/repositories/favorites_repository.dart';
import 'domain/repositories/learning_repository.dart';
import 'presentation/home/cubit/home_cubit.dart';
import 'presentation/home/screens/home_screen.dart';

class LearningApp extends StatelessWidget {
  const LearningApp({
    super.key,
    required this.learningRepository,
    required this.favoritesRepository,
    required this.httpClient,
  });

  final LearningRepository learningRepository;
  final FavoritesRepository favoritesRepository;
  final http.Client httpClient;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<LearningRepository>.value(value: learningRepository),
        RepositoryProvider<FavoritesRepository>.value(value: favoritesRepository),
      ],
      child: HttpClientScope(
        client: httpClient,
        child: MaterialApp(
          title: 'Learning App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          builder: (context, child) => ColoredBox(
            color: AppColors.border,
            child: Center(
              child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 520), child: child),
            ),
          ),
          home: BlocProvider(
            create: (context) => HomeCubit(context.read<LearningRepository>())..load(),
            child: const HomeScreen(),
          ),
        ),
      ),
    );
  }
}
