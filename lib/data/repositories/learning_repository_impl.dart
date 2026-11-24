import '../../core/errors/data_exception.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/home.dart';
import '../../domain/repositories/learning_repository.dart';
import '../datasources/learning_data_source.dart';
import '../models/course_models.dart';
import '../models/home_models.dart';

class LearningRepositoryImpl implements LearningRepository {
  const LearningRepositoryImpl(this._dataSource);

  final LearningDataSource _dataSource;

  @override
  Future<HomeData> getHomeData() => _parse('feed', _dataSource.fetchFeed, HomeDataModel.fromJson);

  @override
  Future<CourseOverview> getCourseOverview() =>
      _parse('feed/details', _dataSource.fetchFeedDetails, CourseOverviewModel.fromJson);

  Future<T> _parse<T>(
    String endpoint,
    Future<Map<String, dynamic>> Function() fetch,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final json = await fetch();
    try {
      return fromJson(json);
    } on TypeError catch (error) {
      throw DataException('The response of "$endpoint" has an unexpected format.', error);
    }
  }
}
