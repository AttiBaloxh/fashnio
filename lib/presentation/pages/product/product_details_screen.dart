import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/models/home_models.dart';
import '../../state_managements/providers/product_details_provider.dart';
import '../../state_managements/providers/wishlist_provider.dart';
import '../../state_managements/providers/cart_provider.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../config/router/app_router.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductDetailsProvider>().reset(
        widget.product.sizes.isNotEmpty ? widget.product.sizes[1] : null,
        widget.product.colors.isNotEmpty ? widget.product.colors[1] : null,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    bool hasSize =
        widget.product.category == "Clothes" ||
        widget.product.category == "Shoes";

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [_buildContent(hasSize), _buildBottomBar(), _buildHeader()],
      ),
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildContent(bool hasSize) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageCarousel(),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleRow(),
                const SizedBox(height: 12),
                _buildRatingRow(),
                const Divider(height: 48),
                Text(
                  'Description',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.product.description,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: AppColors.grey500,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasSize) ...[
                      Expanded(child: _buildSizeSelector()),
                      const SizedBox(width: 24),
                    ],
                    Expanded(child: _buildColorSelector()),
                  ],
                ),
                const SizedBox(height: 24),
                _buildQuantitySelector(),
                const SizedBox(height: 100), // Space for bottom bar
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 380,
          width: double.infinity,
          color: AppColors.grey100,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(40.0),
                child: Hero(
                  tag: widget.product.id,
                  child: Image.network(
                    widget.product.image,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 24,
          child: Row(
            children: List.generate(
              5,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: _currentPage == index ? 24 : 8,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.black : Colors.black12,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.product.name,
            style: GoogleFonts.outfit(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Consumer<WishlistProvider>(
          builder: (context, provider, child) {
            return FutureBuilder<bool>(
              future: provider.isWishlisted(widget.product.id),
              builder: (context, snapshot) {
                final isFavorite = snapshot.data ?? widget.product.isFavorite;
                return IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.black,
                    size: 28,
                  ),
                  onPressed: () => provider.toggleWishlist(widget.product),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildRatingRow() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.reviews,
          arguments: {
            'rating': widget.product.rating,
            'reviewsCount': widget.product.reviews,
          },
        );
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${widget.product.reviews} sold',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.star, color: Colors.orange, size: 20),
          const SizedBox(width: 4),
          Text(
            '${widget.product.rating} (${widget.product.reviews} reviews)',
            style: GoogleFonts.outfit(fontSize: 14, color: AppColors.grey500),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black45),
        ],
      ),
    );
  }

  Widget _buildSizeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Size',
          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Consumer<ProductDetailsProvider>(
          builder: (context, provider, child) {
            return SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.product.sizes.length,
                itemBuilder: (context, index) {
                  final size = widget.product.sizes[index];
                  final isSelected = provider.selectedSize == size;
                  return GestureDetector(
                    onTap: () => provider.selectSize(size),
                    child: Container(
                      width: 45,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        size,
                        style: GoogleFonts.outfit(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Consumer<ProductDetailsProvider>(
          builder: (context, provider, child) {
            return Row(
              children: widget.product.colors.map((color) {
                final isSelected = provider.selectedColor == color;
                return GestureDetector(
                  onTap: () => provider.selectColor(color),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Color(color),
                        shape: BoxShape.circle,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            )
                          : null,
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        Text(
          'Quantity',
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Consumer<ProductDetailsProvider>(
            builder: (context, provider, child) {
              return Row(
                children: [
                  _buildQtyBtn(
                    Icons.remove,
                    () => provider.setQuantity(provider.quantity - 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '${provider.quantity}',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildQtyBtn(
                    Icons.add,
                    () => provider.setQuantity(provider.quantity + 1),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: Colors.black, size: 24),
    );
  }

  Widget _buildBottomBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 110,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black12)),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total price',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: AppColors.grey500,
                  ),
                ),
                Consumer<ProductDetailsProvider>(
                  builder: (context, provider, child) {
                    final total = widget.product.price * provider.quantity;
                    return Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Consumer2<ProductDetailsProvider, CartProvider>(
                builder: (context, detailsProvider, cartProvider, child) {
                  return ElevatedButton.icon(
                    onPressed: () {
                      cartProvider.addToCart(
                        widget.product,
                        quantity: detailsProvider.quantity,
                        size: detailsProvider.selectedSize,
                        color: detailsProvider.selectedColor,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "${widget.product.name} added to cart!",
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    icon: const Icon(Icons.shopping_bag, size: 20),
                    label: Text(
                      'Add to Cart',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
