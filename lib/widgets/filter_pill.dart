import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class FilterPill extends StatelessWidget {
  const FilterPill({super.key, required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: selected ? null : Border.all(color: AppColors.grey100),
      ),
      child: Text(
        label,
        style: AppTextStyles.smallMedium(
          color: selected ? AppColors.white : AppColors.grey400,
        ),
      ),
    );
  }
}
