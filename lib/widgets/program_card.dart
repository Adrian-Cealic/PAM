import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'icon_stat.dart';

class ProgramCard extends StatelessWidget {
  const ProgramCard({
    super.key,
    required this.title,
    required this.calories,
    required this.minutes,
    required this.imageAsset,
    this.imageAlignment = Alignment.center,
    this.isPro = false,
  });

  static const double height = 184;

  final String title;
  final String calories;
  final String minutes;
  final String imageAsset;
  final Alignment imageAlignment;
  final bool isPro;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imageAsset,
              fit: BoxFit.cover,
              alignment: imageAlignment,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x00000000), Color(0xCC000000)],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (isPro) const _ProBadge(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.mediumSemibold(
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconStat(
                              iconAsset: 'assets/icons/flame.svg',
                              label: calories,
                            ),
                            IconStat(
                              iconAsset: 'assets/icons/clock.svg',
                              label: minutes,
                            ),
                          ],
                        ),
                      ],
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

class _ProBadge extends StatelessWidget {
  const _ProBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('assets/icons/crown.svg', width: 14, height: 14),
          const SizedBox(width: 3),
          Text(
            'Pro',
            style: AppTextStyles.xSmallMedium(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
