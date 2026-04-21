import 'package:flutter/material.dart';
import '../../../domain/models/home_models.dart';
import '../../../domain/repositories/wishlist_repository.dart';

class WishlistProvider with ChangeNotifier {
  final WishlistRepository repository;

  WishlistProvider({required this.repository});

  List<Product> _wishlistItems = [];
  bool _isLoading = false;
  String _selectedCategory = "All";

  List<Product> get wishlistItems => _wishlistItems;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  List<Product> get filteredItems {
    if (_selectedCategory == "All") return _wishlistItems;
    return _wishlistItems
        .where((p) => p.category == _selectedCategory)
        .toList();
  }

  Future<void> fetchWishlist() async {
    _isLoading = true;
    notifyListeners();
    _wishlistItems = await repository.getWishlist();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleWishlist(Product product) async {
    await repository.toggleWishlist(product);
    await fetchWishlist(); // Refresh the list
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<bool> isWishlisted(String productId) {
    return repository.isWishlisted(productId);
  }
}
