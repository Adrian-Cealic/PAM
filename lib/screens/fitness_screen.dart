import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/amenity_tile.dart';
import '../widgets/primary_button.dart';
import '../widgets/status_bar.dart';

class FitnessScreen extends StatelessWidget {
  const FitnessScreen({super.key});

  static const double _gutter = 24;
  static const double _heroHeight = 350;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.white,
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 108),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Hero(height: _heroHeight),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: _gutter),
                  child: _GymSummary(),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: _gutter),
                  child: _Description(),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: _gutter),
                  child: _Amenities(),
                ),
              ],
            ),
          ),
          const Align(alignment: Alignment.bottomCenter, child: _ReserveBar()),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/gym_hero.jpg', fit: BoxFit.cover),
          ),
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: StatusBar(mode: StatusBarMode.dark),
          ),
          const Positioned(
            left: FitnessScreen._gutter,
            right: FitnessScreen._gutter,
            top: 60,
            child: _TopBar(),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0x80FFFFFF),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              'assets/icons/arrow_left.svg',
              width: 24,
              height: 24,
            ),
          ),
          SvgPicture.asset(
            'assets/icons/dots_vertical.svg',
            width: 24,
            height: 24,
          ),
        ],
      ),
    );
  }
}

class _GymSummary extends StatelessWidget {
  const _GymSummary();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.grey100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/star_filled.svg',
                width: 16,
                height: 16,
              ),
              const SizedBox(width: 8),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '4.5 ',
                      style: AppTextStyles.smallSemibold(),
                    ),
                    TextSpan(
                      text: '(1,232 reviews)',
                      style: AppTextStyles.smallRegular(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Mid City Gym Training', style: AppTextStyles.h4Bold()),
          const SizedBox(height: 8),
          Text('California, New York', style: AppTextStyles.smallRegular()),
        ],
      ),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description();

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text:
                'Lorem ipsum dolor sit amet consectetur. Blandit vitae aliquet '
                'eros laoreet quam sollicitudin. Duis non eu habitant id vel '
                'nisi eget amet tellus... ',
            style: AppTextStyles.smallRegular(),
          ),
          TextSpan(
            text: 'Read more',
            style: AppTextStyles.smallMedium(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _Amenities extends StatelessWidget {
  const _Amenities();

  static const _items = [
    ('assets/icons/ironing_steam.svg', 'Showers'),
    ('assets/icons/layout_list.svg', 'Lockers'),
    ('assets/icons/wifi.svg', 'Free Wi-fi'),
    ('assets/icons/wifi.svg', 'Free Wi-fi'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Amenities', style: AppTextStyles.largeSemibold()),
        const SizedBox(height: 16),
        for (var row = 0; row * 2 < _items.length; row++) ...[
          if (row > 0) const SizedBox(height: 16),
          Row(
            children: [
              for (var col = 0; col < 2; col++) ...[
                if (col > 0) const SizedBox(width: 16),
                Expanded(
                  child: AmenityTile(
                    iconAsset: _items[row * 2 + col].$1,
                    label: _items[row * 2 + col].$2,
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

class _ReserveBar extends StatelessWidget {
  const _ReserveBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, -10),
            blurRadius: 50,
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 16, 25, 40),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Total',
                        style: AppTextStyles.smallMedium(
                          color: AppColors.grey400,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '\$69.00 ',
                              style: AppTextStyles.h6Bold(),
                            ),
                            TextSpan(
                              text: '/week',
                              style: AppTextStyles.smallMedium(
                                color: AppColors.grey400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: PrimaryButton(
                    label: 'Reserve',
                    expand: true,
                    height: 52,
                    radius: 12,
                    labelStyle: AppTextStyles.mediumSemibold(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SvgPicture.asset(
              'assets/icons/home_indicator.svg',
              height: 34,
              fit: BoxFit.fitWidth,
            ),
          ),
        ],
      ),
    );
  }
}
