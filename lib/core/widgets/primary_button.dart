import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.label, required this.onPressed, this.icon, this.compact = false});

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final style = FilledButton.styleFrom(
      backgroundColor: AppColors.primary,
      disabledBackgroundColor: AppColors.primarySoft,
      disabledForegroundColor: Colors.white,
      textStyle: compact ? AppTextStyles.button.copyWith(fontSize: 13) : AppTextStyles.button,
      padding: EdgeInsets.symmetric(horizontal: compact ? 16 : 24, vertical: compact ? 10 : 16),
      minimumSize: Size(0, compact ? 36 : 52),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(compact ? 10 : 14)),
    );
    final text = Text(label, maxLines: 1, overflow: TextOverflow.ellipsis);

    if (icon == null) {
      return FilledButton(onPressed: onPressed, style: style, child: text);
    }
    return FilledButton.icon(onPressed: onPressed, style: style, icon: Icon(icon, size: 20), label: text);
  }
}
