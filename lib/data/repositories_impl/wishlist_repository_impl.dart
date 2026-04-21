import '../../domain/models/home_models.dart';
import '../../domain/repositories/wishlist_repository.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  // In-memory storage for demonstration.
  // In a real app, this would use SharedPreferences or a Database.
  static final List<Product> _wishlist = [];

  @override
  Future<List<Product>> getWishlist() async {
    // Simulate network/disk delay
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_wishlist);
  }

  @override
  Future<void> toggleWishlist(Product product) async {
    final index = _wishlist.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _wishlist.removeAt(index);
    } else {
      _wishlist.add(product);
    }
  }

  @override
  Future<bool> isWishlisted(String productId) async {
    return _wishlist.any((p) => p.id == productId);
  }
}
