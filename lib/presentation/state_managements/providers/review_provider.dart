import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../domain/models/review_model.dart';

class ReviewProvider with ChangeNotifier {
  List<Review> _reviews = [];
  bool _isLoading = false;
  int _selectedFilter = 0; // 0 for All, 5 for 5 stars, etc.

  List<Review> get reviews => _reviews;
  bool get isLoading => _isLoading;
  int get selectedFilter => _selectedFilter;

  List<Review> get filteredReviews {
    if (_selectedFilter == 0) return _reviews;
    return _reviews.where((r) => r.rating == _selectedFilter).toList();
  }

  Future<void> fetchReviews() async {
    _isLoading = true;
    notifyListeners();

    try {
      final String response = await rootBundle.loadString(
        'assets/data/reviews.json',
      );
      final List<dynamic> data = json.decode(response);
      _reviews = data.map((json) => Review.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Error fetching reviews: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setFilter(int filter) {
    _selectedFilter = filter;
    notifyListeners();
  }
}
