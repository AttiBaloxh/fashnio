import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/models/home_models.dart';
import 'product_grid.dart';

class ProductListTemplate extends StatelessWidget {
  final String title;
  final List<Product> products;
  final bool isLoading;
  final List<String>? categories;
  final String? selectedCategory;
  final Function(String)? onCategorySelected;
  final Widget? emptyState;
  final bool showCategorySelector;

  const ProductListTemplate({
    super.key,
    required this.title,
    required this.products,
    required this.isLoading,
    this.categories,
    this.selectedCategory,
    this.onCategorySelected,
    this.emptyState,
    this.showCategorySelector = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : Column(
              children: [
                if (showCategorySelector && categories != null)
                  _buildCategorySelector(),
                Expanded(
                  child: products.isEmpty
                      ? (emptyState ?? _buildDefaultEmptyState())
                      : SingleChildScrollView(
                          child: ProductGrid(products: products),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildCategorySelector() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories!.length,
        itemBuilder: (context, index) {
          final category = categories![index];
          final isSelected = selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(
                category,
                style: GoogleFonts.outfit(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected && onCategorySelected != null) {
                  onCategorySelected!(category);
                }
              },
              selectedColor: Colors.black,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? Colors.black : Colors.black12,
                ),
              ),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildDefaultEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "No products found",
            style: GoogleFonts.outfit(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
