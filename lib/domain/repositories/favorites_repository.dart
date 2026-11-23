abstract interface class FavoritesRepository {
  Future<Set<String>> loadFavorites();

  Future<Set<String>> toggleFavorite(String lessonId);
}
