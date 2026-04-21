import '../models/home_models.dart';

abstract class WishlistRepository {
  Future<List<Product>> getWishlist();
  Future<void> toggleWishlist(Product product);
  Future<bool> isWishlisted(String productId);
}
