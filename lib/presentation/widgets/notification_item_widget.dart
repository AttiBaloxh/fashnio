import 'package:flutter/material.dart';
import '../../domain/models/notification_model.dart';
import '../../../utils/constants/app_constants.dart';

class NotificationItemWidget extends StatelessWidget {
  final NotificationModel notification;
  final bool isDarkMode;

  const NotificationItemWidget({
    super.key,
    required this.notification,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildIcon(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey[400] : AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    IconData iconData;
    switch (notification.type) {
      case 'discount':
        iconData = Icons.percent;
        break;
      case 'wallet':
        iconData = Icons.account_balance_wallet;
        break;
      case 'service':
        iconData = Icons.location_on;
        break;
      case 'card':
        iconData = Icons.credit_card;
        break;
      case 'account':
        iconData = Icons.person;
        break;
      default:
        iconData = Icons.notifications;
    }

    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: Colors.white, size: 24),
    );
  }
}
