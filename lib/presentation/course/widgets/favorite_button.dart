import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.isFavorite, required this.onPressed, required this.keyId});

  final bool isFavorite;
  final VoidCallback onPressed;
  final String keyId;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: Key('favorite_$keyId'),
      tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
      onPressed: onPressed,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          key: ValueKey(isFavorite),
          color: isFavorite ? AppColors.favorite : AppColors.textMuted,
        ),
      ),
    );
  }
}
