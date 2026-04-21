import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state_managements/providers/home_provider.dart';
import '../../widgets/product_list_template.dart';

class PopularProductsScreen extends StatelessWidget {
  const PopularProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        final products = homeProvider.products.where((p) {
          return homeProvider.selectedPopularCategory == "All" ||
              p.category == homeProvider.selectedPopularCategory;
        }).toList();

        return ProductListTemplate(
          title: 'Most Popular',
          products: products,
          isLoading: homeProvider.isLoading,
          categories: ["All", ...homeProvider.categories.map((c) => c.name)],
          selectedCategory: homeProvider.selectedPopularCategory,
          onCategorySelected: (category) =>
              homeProvider.selectPopularCategory(category),
        );
      },
    );
  }
}
