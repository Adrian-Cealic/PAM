import '../entities/course.dart';
import '../entities/home.dart';

abstract interface class LearningRepository {
  Future<HomeData> getHomeData();

  Future<CourseOverview> getCourseOverview();
}
