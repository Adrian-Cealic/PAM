import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../domain/entities/course.dart';

class EnrollBar extends StatelessWidget {
  const EnrollBar({
    super.key,
    required this.price,
    required this.enroll,
    required this.enrolled,
    required this.onEnroll,
  });

  final CoursePrice price;
  final EnrollAction enroll;
  final bool enrolled;
  final VoidCallback onEnroll;

  @override
  Widget build(BuildContext context) {
    final canEnroll = enroll.enabled && !enrolled;

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: [BoxShadow(color: Color(0x14101012), blurRadius: 20, offset: Offset(0, -6))],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Price', style: AppTextStyles.caption),
                  Text(price.label, style: AppTextStyles.title.copyWith(color: AppColors.primary)),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: PrimaryButton(
                  key: const Key('enroll_button'),
                  label: enrolled ? 'Enrolled' : enroll.label,
                  icon: enrolled ? Icons.check_circle_outline : null,
                  onPressed: canEnroll ? onEnroll : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
