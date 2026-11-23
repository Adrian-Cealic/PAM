import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';
import 'network_svg_icon.dart';

class IconLabel extends StatelessWidget {
  const IconLabel({super.key, required this.iconUrl, required this.label, this.iconSize = 18});

  final String iconUrl;
  final String label;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        NetworkSvgIcon(iconUrl, size: iconSize),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(fontSize: 13),
          ),
        ),
      ],
    );
  }
}
