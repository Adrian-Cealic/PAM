import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../core/widgets/network_svg_icon.dart';
import '../../../domain/entities/course.dart';

class CourseHeroCard extends StatelessWidget {
  const CourseHeroCard({super.key, required this.hero, this.onPlay, this.showStats = true});

  final CourseHero hero;
  final VoidCallback? onPlay;
  final bool showStats;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(20);
    return AspectRatio(
      aspectRatio: 16 / 10,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppNetworkImage(hero.imageUrl, borderRadius: radius),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: radius,
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x33101012), Color(0x00101012), Color(0x99101012)],
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 16,
            right: 16,
            child: Text(
              hero.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.6,
              ),
            ),
          ),
          Center(
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),
              elevation: 4,
              child: InkWell(
                key: const Key('hero_play'),
                customBorder: const CircleBorder(),
                onTap: onPlay,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: NetworkSvgIcon(hero.playIconUrl, size: 38, fallback: Icons.play_arrow),
                ),
              ),
            ),
          ),
          if (showStats)
            Positioned(
              left: 16,
              bottom: 14,
              right: 16,
              child: Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _HeroStat(label: '${hero.videoCount} videos'),
                  _HeroStat(label: '${hero.classCount} classes'),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.22), borderRadius: BorderRadius.circular(20)),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }
}
