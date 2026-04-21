import 'dart:convert';
import 'package:flutter/services.dart';

abstract class HomeLocalDataSource {
  Future<Map<String, dynamic>> getHomeData();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  @override
  Future<Map<String, dynamic>> getHomeData() async {
    final String response = await rootBundle.loadString(
      'assets/data/home_data.json',
    );
    final data = await json.decode(response);
    return data;
  }
}
