import '../../core/errors/data_exception.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/home.dart';
import '../../domain/repositories/learning_repository.dart';
import '../datasources/learning_local_data_source.dart';
import '../models/course_models.dart';
import '../models/home_models.dart';

class LearningRepositoryImpl implements LearningRepository {
  const LearningRepositoryImpl(this._dataSource);

  final LearningLocalDataSource _dataSource;

  @override
  Future<HomeData> getHomeData() => _parse('homePage', HomeDataModel.fromJson);

  @override
  Future<CourseOverview> getCourseOverview() => _parse('courseOverviewPage', CourseOverviewModel.fromJson);

  Future<T> _parse<T>(String section, T Function(Map<String, dynamic>) fromJson) async {
    final json = await _dataSource.loadSection(section);
    try {
      return fromJson(json);
    } on TypeError catch (error) {
      throw DataException('Section "$section" has an unexpected format.', error);
    }
  }
}
