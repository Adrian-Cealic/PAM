import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    super.key,
    required this.label,
    required this.title,
    required this.progressLabel,
  });

  final String label;
  final String title;
  final String progressLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTextStyles.smallRegular(color: AppColors.grey300),
              ),
              const SizedBox(height: 4),
              Text(title, style: AppTextStyles.h6Bold(color: AppColors.white)),
            ],
          ),
          SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/progress_ring.svg',
                  width: 50,
                  height: 50,
                ),
                Text(
                  progressLabel,
                  style: AppTextStyles.xSmallMedium(color: AppColors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
