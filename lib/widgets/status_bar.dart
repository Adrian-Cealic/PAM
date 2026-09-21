import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum StatusBarMode { light, dark }

class StatusBar extends StatelessWidget {
  const StatusBar({super.key, this.mode = StatusBarMode.light});

  final StatusBarMode mode;

  @override
  Widget build(BuildContext context) {
    final isLight = mode == StatusBarMode.light;
    final suffix = isLight ? 'light' : 'dark';
    final textColor = isLight ? AppColors.grey900 : AppColors.white;

    return SizedBox(
      height: 44,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('9:41', style: AppTextStyles.clock(color: textColor)),
            SizedBox(
              width: 70.98,
              height: 13,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 2.5,
                    child: SvgPicture.asset(
                      'assets/icons/status_cellular_$suffix.svg',
                      width: 18,
                      height: 10,
                    ),
                  ),
                  Positioned(
                    left: 23,
                    top: 1,
                    child: SvgPicture.asset(
                      'assets/icons/status_wifi_$suffix.svg',
                      width: 15.272,
                      height: 10.965,
                    ),
                  ),
                  Positioned(
                    left: 44,
                    top: 0,
                    child: SvgPicture.asset(
                      'assets/icons/status_battery_$suffix.svg',
                      width: 26.978,
                      height: 13,
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
