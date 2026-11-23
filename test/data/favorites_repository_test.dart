import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/data/repositories/favorites_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('favorites survive a new repository instance (restart)', () async {
    SharedPreferences.setMockInitialValues({});
    final first = FavoritesRepositoryImpl();
    expect(await first.loadFavorites(), isEmpty);
    expect(await first.toggleFavorite('lesson-2'), {'lesson-2'});
    expect(await first.toggleFavorite('lesson-1'), {'lesson-1', 'lesson-2'});

    final restarted = FavoritesRepositoryImpl();
    expect(await restarted.loadFavorites(), {'lesson-1', 'lesson-2'});
    expect(await restarted.toggleFavorite('lesson-2'), {'lesson-1'});

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getStringList(FavoritesRepositoryImpl.storageKey), ['lesson-1']);
  });
}
