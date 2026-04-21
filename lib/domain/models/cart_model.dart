import '../../domain/models/home_models.dart';

class CartItem {
  final Product product;
  int quantity;
  final String? size;
  final int? color;

  CartItem({required this.product, this.quantity = 1, this.size, this.color});

  double get totalPrice => product.price * quantity;
}
