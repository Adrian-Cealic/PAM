import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../domain/entities/home.dart';

class MeetupCard extends StatelessWidget {
  const MeetupCard({super.key, required this.meetup});

  final Meetup meetup;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.primaryTint,
      elevated: false,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meetup.title, style: AppTextStyles.headline.copyWith(color: AppColors.primaryDark)),
                const SizedBox(height: 6),
                Text(meetup.subtitle, style: AppTextStyles.body),
              ],
            ),
          ),
          const SizedBox(width: 12),
          AppNetworkImage(meetup.imageUrl, width: 96, height: 96, borderRadius: BorderRadius.circular(14)),
        ],
      ),
    );
  }
}
