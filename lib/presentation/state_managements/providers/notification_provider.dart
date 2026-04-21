import 'package:flutter/material.dart';
import '../../../domain/models/notification_model.dart';
import '../../../domain/repositories/notification_repository.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationRepository repository;

  NotificationProvider({required this.repository});

  List<NotificationModel> _notifications = [];
  bool _isLoading = false;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;

  Future<void> fetchNotifications() async {
    _isLoading = true;
    notifyListeners();

    try {
      _notifications = await repository.getNotifications();
    } catch (e) {
      debugPrint("Error fetching notifications: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Map<String, List<NotificationModel>> get groupedNotifications {
    final Map<String, List<NotificationModel>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    for (var notification in _notifications) {
      final date = DateTime(
        notification.date.year,
        notification.date.month,
        notification.date.day,
      );

      String key;
      if (date == today) {
        key = "Today";
      } else if (date == yesterday) {
        key = "Yesterday";
      } else {
        // Format as Month Day, Year
        key = _formatDate(notification.date);
      }

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(notification);
    }
    return grouped;
  }

  String _formatDate(DateTime date) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }
}
