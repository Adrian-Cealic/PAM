import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../core/widgets/network_svg_icon.dart';
import '../../../domain/entities/home.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.header});

  final UserHeader header;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                header.greeting,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.headline.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 2),
              Text(
                header.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(color: Colors.white.withValues(alpha: 0.85)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _NotificationBell(iconUrl: header.notificationIconUrl, hasUnread: header.hasUnreadNotifications),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: AppNetworkImage(header.avatarUrl, width: 44, height: 44, borderRadius: BorderRadius.circular(22)),
        ),
      ],
    );
  }
}

class _NotificationBell extends StatelessWidget {
  const _NotificationBell({required this.iconUrl, required this.hasUnread});

  final String iconUrl;
  final bool hasUnread;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: hasUnread ? 'Notifications, unread' : 'Notifications',
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          NetworkSvgIcon(iconUrl, size: 28, fallback: Icons.notifications_none),
          if (hasUnread)
            Positioned(
              right: 2,
              top: 2,
              child: Container(
                key: const Key('unread_badge'),
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: AppColors.star,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
