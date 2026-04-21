import 'package:flutter/material.dart';
import '../../../domain/models/home_models.dart';
import '../../../data/repositories_impl/home_repository_impl.dart';

class HomeProvider with ChangeNotifier {
  final HomeRepository repository;

  HomeProvider({required this.repository});

  User? _user;
  List<SpecialOffer> _offers = [];
  List<Category> _categories = [];
  List<Product> _products = [];
  List<String> _popularCategories = [];
  String _selectedPopularCategory = "All";
  bool _isLoading = false;

  User? get user => _user;
  List<SpecialOffer> get offers => _offers;
  List<Category> get categories => _categories;
  List<Product> get products => _products;
  List<String> get popularCategories => _popularCategories;
  String get selectedPopularCategory => _selectedPopularCategory;
  bool get isLoading => _isLoading;

  Future<void> fetchHomeData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await repository.getHomeData();

      _user = User.fromJson(data['user']);
      _offers = (data['special_offers'] as List)
          .map((e) => SpecialOffer.fromJson(e))
          .toList();
      _categories = (data['categories'] as List)
          .map((e) => Category.fromJson(e))
          .toList();
      _products = (data['products'] as List)
          .map((e) => Product.fromJson(e))
          .toList();
      _popularCategories = List<String>.from(data['popular_categories']);
    } catch (e) {
      debugPrint("Error fetching home data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectPopularCategory(String category) {
    _selectedPopularCategory = category;
    notifyListeners();
  }
}
