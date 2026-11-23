import 'dart:async';

import 'package:learning_app/core/errors/data_exception.dart';
import 'package:learning_app/domain/entities/course.dart';
import 'package:learning_app/domain/entities/home.dart';
import 'package:learning_app/domain/repositories/favorites_repository.dart';
import 'package:learning_app/domain/repositories/learning_repository.dart';

const iconUrl = 'https://example.com/icon.svg';
const imageUrl = 'https://example.com/image.jpg';

Lesson lesson(String id, String title, int seconds, {bool locked = false}) => Lesson(
  id: id,
  title: title,
  duration: '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}',
  durationSeconds: seconds,
  completed: false,
  locked: locked,
  playIconUrl: iconUrl,
  arrowIconUrl: iconUrl,
);

final sampleLessons = [
  lesson('l1', 'Introduction to React', 268),
  lesson('l2', 'Understanding React', 372),
  lesson('l3', 'Create first React project', 2638),
  lesson('l4', 'Build React', 1578, locked: true),
];

CourseOverview sampleOverview({List<Lesson>? lessons, String description = ''}) => CourseOverview(
  screenTitle: 'Course Overview',
  backIconUrl: iconUrl,
  course: Course(
    id: 'react',
    title: 'React Front To back',
    duration: '6h 30min',
    durationMinutes: 390,
    lessonCount: 7,
    rating: 4.9,
    hero: const CourseHero(
      label: 'SPOKEN ENGLISH',
      imageUrl: imageUrl,
      playIconUrl: iconUrl,
      videoCount: 75,
      classCount: 35,
    ),
    tabs: const [
      CourseTab(id: 'lessons', label: 'Lessons'),
      CourseTab(id: 'description', label: 'Description'),
    ],
    selectedTabId: 'lessons',
    lessons: lessons ?? sampleLessons,
    description: description,
  ),
  price: const CoursePrice(label: 'Free', amount: 0, currency: 'USD'),
  enroll: const EnrollAction(label: 'Enroll Now', enabled: true),
  icons: const CourseIcons(durationIconUrl: iconUrl, lessonsIconUrl: iconUrl, ratingIconUrl: iconUrl),
);

const sampleHome = HomeData(
  header: UserHeader(
    greeting: 'Hi, Kristin',
    subtitle: 'Let’s start learning',
    avatarUrl: imageUrl,
    hasUnreadNotifications: true,
    notificationIconUrl: iconUrl,
  ),
  learnedToday: DailyProgress(
    title: 'Learned today',
    learnedMinutes: 46,
    goalMinutes: 60,
    formatted: '46min / 60min',
    progress: 0.7667,
  ),
  myCourses: SectionLink(title: 'My courses', actionLabel: 'My courses'),
  learningPrompt: LearningPrompt(
    title: 'What do you want to learn today?',
    actionLabel: 'Get Started',
    imageUrl: imageUrl,
  ),
  learningPlan: LearningPlan(
    title: 'Learning Plan',
    items: [
      LearningPlanItem(
        id: 'p1',
        title: 'Packaging Design',
        completed: 40,
        total: 48,
        progress: 0.8333,
        progressIconUrl: iconUrl,
      ),
      LearningPlanItem(
        id: 'p2',
        title: 'Product Design',
        completed: 6,
        total: 24,
        progress: 0.25,
        progressIconUrl: iconUrl,
      ),
    ],
  ),
  meetup: Meetup(title: 'Meetup', subtitle: 'Off-line exchange of learning experience', imageUrl: imageUrl),
);

class FakeLearningRepository implements LearningRepository {
  FakeLearningRepository({CourseOverview? overview, this.home = sampleHome, this.failuresBeforeSuccess = 0})
    : overview = overview ?? sampleOverview();

  CourseOverview overview;
  HomeData home;
  int failuresBeforeSuccess;
  Completer<void>? gate;
  int calls = 0;

  Future<T> _respond<T>(T value) async {
    calls++;
    if (gate != null) await gate!.future;
    if (failuresBeforeSuccess > 0) {
      failuresBeforeSuccess--;
      throw const DataException('Could not read "assets/data/lab_v4.json".');
    }
    return value;
  }

  @override
  Future<CourseOverview> getCourseOverview() => _respond(overview);

  @override
  Future<HomeData> getHomeData() => _respond(home);
}

class InMemoryFavoritesRepository implements FavoritesRepository {
  InMemoryFavoritesRepository([Set<String>? initial]) : favorites = {...?initial};

  final Set<String> favorites;
  bool failOnToggle = false;

  @override
  Future<Set<String>> loadFavorites() async => {...favorites};

  @override
  Future<Set<String>> toggleFavorite(String lessonId) async {
    if (failOnToggle) throw const DataException('Could not update favorites.');
    if (!favorites.remove(lessonId)) favorites.add(lessonId);
    return {...favorites};
  }
}
