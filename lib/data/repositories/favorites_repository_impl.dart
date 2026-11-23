import 'package:shared_preferences/shared_preferences.dart';

import '../../core/errors/data_exception.dart';
import '../../domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl({Future<SharedPreferences>? preferences})
    : _preferences = preferences ?? SharedPreferences.getInstance();

  static const storageKey = 'favorite_lesson_ids';

  final Future<SharedPreferences> _preferences;

  @override
  Future<Set<String>> loadFavorites() => _guard('Could not load favorites.', _read);

  @override
  Future<Set<String>> toggleFavorite(String lessonId) {
    return _guard('Could not update favorites.', () async {
      final favorites = await _read();
      if (!favorites.remove(lessonId)) favorites.add(lessonId);
      final prefs = await _preferences;
      await prefs.setStringList(storageKey, favorites.toList()..sort());
      return favorites;
    });
  }

  Future<Set<String>> _read() async {
    final prefs = await _preferences;
    return (prefs.getStringList(storageKey) ?? const <String>[]).toSet();
  }

  Future<Set<String>> _guard(String message, Future<Set<String>> Function() action) async {
    try {
      return await action();
    } catch (error) {
      throw DataException(message, error);
    }
  }
}
