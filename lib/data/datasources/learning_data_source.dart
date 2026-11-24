abstract interface class LearningDataSource {
  Future<Map<String, dynamic>> fetchFeed();

  Future<Map<String, dynamic>> fetchFeedDetails();
}
