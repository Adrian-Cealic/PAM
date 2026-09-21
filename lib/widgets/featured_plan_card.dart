import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'icon_stat.dart';
import 'primary_button.dart';

class FeaturedPlanCard extends StatelessWidget {
  const FeaturedPlanCard({
    super.key,
    required this.title,
    required this.duration,
    required this.frequency,
    required this.imageAsset,
  });

  static const double width = 296;
  static const double height = 144;

  final String title;
  final String duration;
  final String frequency;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: height * 0.0033,
              width: width * 1.155,
              height: height * 1.58,
              child: Image.asset(imageAsset, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.h6Bold(color: AppColors.white),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconStat(
                            iconAsset: 'assets/icons/barbell.svg',
                            label: duration,
                            iconSize: 16,
                            gap: 4,
                            textStyle: AppTextStyles.xSmallRegular(),
                          ),
                          const SizedBox(width: 8),
                          SvgPicture.asset(
                            'assets/icons/dot.svg',
                            width: 4,
                            height: 4,
                          ),
                          const SizedBox(width: 8),
                          Text(frequency, style: AppTextStyles.xSmallRegular()),
                        ],
                      ),
                    ],
                  ),
                  PrimaryButton(
                    label: 'Start Now',
                    height: 32,
                    radius: 6,
                    labelStyle: AppTextStyles.xSmallSemibold(
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
