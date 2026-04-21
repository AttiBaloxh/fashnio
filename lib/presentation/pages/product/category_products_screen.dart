import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state_managements/providers/home_provider.dart';
import '../../widgets/product_list_template.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String categoryName;

  const CategoryProductsScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        final products = homeProvider.products
            .where((p) => p.category == categoryName)
            .toList();

        return ProductListTemplate(
          title: categoryName,
          products: products,
          isLoading: homeProvider.isLoading,
          showCategorySelector: false,
        );
      },
    );
  }
}
