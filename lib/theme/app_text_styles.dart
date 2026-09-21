import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  static const _family = 'PlusJakartaSans';

  static TextStyle _jakarta({
    required double size,
    required FontWeight weight,
    required double height,
    double letterSpacing = 0,
    Color color = AppColors.ink,
  }) {
    return TextStyle(
      fontFamily: _family,
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  static TextStyle h4Bold({Color color = AppColors.ink}) =>
      _jakarta(size: 24, weight: FontWeight.w700, height: 1.5, color: color);

  static TextStyle h6Bold({Color color = AppColors.ink}) =>
      _jakarta(size: 18, weight: FontWeight.w700, height: 1.4, color: color);

  static TextStyle largeSemibold({Color color = AppColors.ink}) =>
      _jakarta(size: 18, weight: FontWeight.w600, height: 1.55, color: color);

  static TextStyle mediumSemibold({Color color = AppColors.ink}) => _jakarta(
    size: 16,
    weight: FontWeight.w600,
    height: 1.55,
    letterSpacing: -0.32,
    color: color,
  );

  static TextStyle smallSemibold({Color color = AppColors.ink}) => _jakarta(
    size: 14,
    weight: FontWeight.w600,
    height: 1.55,
    letterSpacing: -0.28,
    color: color,
  );

  static TextStyle smallMedium({Color color = AppColors.ink}) => _jakarta(
    size: 14,
    weight: FontWeight.w500,
    height: 1.55,
    letterSpacing: -0.28,
    color: color,
  );

  static TextStyle smallRegular({Color color = AppColors.grey400}) => _jakarta(
    size: 14,
    weight: FontWeight.w400,
    height: 1.55,
    letterSpacing: -0.28,
    color: color,
  );

  static TextStyle xSmallSemibold({Color color = AppColors.ink}) => _jakarta(
    size: 12,
    weight: FontWeight.w600,
    height: 1.55,
    letterSpacing: -0.24,
    color: color,
  );

  static TextStyle xSmallMedium({Color color = AppColors.ink}) => _jakarta(
    size: 12,
    weight: FontWeight.w500,
    height: 1.55,
    letterSpacing: -0.24,
    color: color,
  );

  static TextStyle xSmallRegular({Color color = AppColors.white}) => _jakarta(
    size: 12,
    weight: FontWeight.w400,
    height: 1.55,
    letterSpacing: -0.24,
    color: color,
  );

  static TextStyle statSemibold({Color color = AppColors.grey200}) => _jakarta(
    size: 11,
    weight: FontWeight.w600,
    height: 1.55,
    letterSpacing: -0.22,
    color: color,
  );

  static TextStyle clock({required Color color}) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1,
    color: color,
    leadingDistribution: TextLeadingDistribution.even,
  );
}
