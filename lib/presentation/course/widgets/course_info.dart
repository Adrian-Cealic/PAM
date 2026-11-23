import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/icon_label.dart';
import '../../../domain/entities/course.dart';

class CourseInfo extends StatelessWidget {
  const CourseInfo({super.key, required this.course, required this.icons});

  final Course course;
  final CourseIcons icons;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(course.title, style: AppTextStyles.title),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          runSpacing: 6,
          children: [
            IconLabel(iconUrl: icons.durationIconUrl, label: course.duration),
            IconLabel(iconUrl: icons.lessonsIconUrl, label: '${course.lessonCount} Lessons'),
            IconLabel(iconUrl: icons.ratingIconUrl, label: course.rating.toStringAsFixed(1), iconSize: 20),
          ],
        ),
      ],
    );
  }
}
