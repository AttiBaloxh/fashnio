import 'dart:convert';
import 'package:flutter/services.dart';

abstract class NotificationLocalDataSource {
  Future<List<dynamic>> getNotifications();
}

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  @override
  Future<List<dynamic>> getNotifications() async {
    final String response = await rootBundle.loadString(
      'assets/data/notifications.json',
    );
    final data = await json.decode(response);
    return data;
  }
}
