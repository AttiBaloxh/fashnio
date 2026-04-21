import 'package:flutter/material.dart';

class ProductDetailsProvider with ChangeNotifier {
  int _quantity = 1;
  String? _selectedSize;
  int? _selectedColor;

  int get quantity => _quantity;
  String? get selectedSize => _selectedSize;
  int? get selectedColor => _selectedColor;

  void setQuantity(int val) {
    if (val < 1) return;
    _quantity = val;
    notifyListeners();
  }

  void selectSize(String size) {
    _selectedSize = size;
    notifyListeners();
  }

  void selectColor(int color) {
    _selectedColor = color;
    notifyListeners();
  }

  void reset(String? initialSize, int? initialColor) {
    _quantity = 1;
    _selectedSize = initialSize;
    _selectedColor = initialColor;
  }
}
