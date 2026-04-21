import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state_managements/providers/wishlist_provider.dart';
import '../../state_managements/providers/home_provider.dart';
import '../../widgets/product_list_template.dart';
import 'package:google_fonts/google_fonts.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WishlistProvider>().fetchWishlist();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<WishlistProvider, HomeProvider>(
      builder: (context, wishlistProvider, homeProvider, child) {
        return ProductListTemplate(
          title: 'My Wishlist',
          products: wishlistProvider.filteredItems,
          isLoading: wishlistProvider.isLoading,
          categories: ["All", ...homeProvider.categories.map((c) => c.name)],
          selectedCategory: wishlistProvider.selectedCategory,
          onCategorySelected: (category) =>
              wishlistProvider.setCategory(category),
          emptyState: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  "Your wishlist is empty",
                  style: GoogleFonts.outfit(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
