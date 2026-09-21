import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.actionLabel});

  final String title;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: Text(title, style: AppTextStyles.largeSemibold())),
        if (actionLabel != null)
          Text(
            actionLabel!,
            style: AppTextStyles.smallSemibold(color: AppColors.primary),
          ),
      ],
    );
  }
}
