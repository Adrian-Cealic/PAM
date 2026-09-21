import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.height,
    required this.radius,
    required this.labelStyle,
    this.horizontalPadding = 16,
    this.expand = false,
  });

  final String label;
  final double height;
  final double radius;
  final TextStyle labelStyle;
  final double horizontalPadding;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: expand ? double.infinity : null,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0D0D12),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(label, style: labelStyle)],
      ),
    );
  }
}
