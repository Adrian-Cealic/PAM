import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_text_styles.dart';

class IconStat extends StatelessWidget {
  const IconStat({
    super.key,
    required this.iconAsset,
    required this.label,
    this.iconSize = 12,
    this.gap = 3,
    this.textStyle,
  });

  final String iconAsset;
  final String label;
  final double iconSize;
  final double gap;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(iconAsset, width: iconSize, height: iconSize),
        SizedBox(width: gap),
        Text(label, style: textStyle ?? AppTextStyles.statSemibold()),
      ],
    );
  }
}
