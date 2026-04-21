import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../state_managements/providers/cart_provider.dart';
import '../../state_managements/providers/checkout_provider.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../domain/models/cart_model.dart';
import '../../../config/router/app_router.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

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
          'Checkout',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer2<CartProvider, CheckoutProvider>(
        builder: (context, cartProvider, checkoutProvider, child) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildSectionHeader('Shipping Address'),
                    const SizedBox(height: 16),
                    _buildAddressCard(context, checkoutProvider),
                    const SizedBox(height: 24),
                    const Divider(color: Colors.black12),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Order List'),
                    const SizedBox(height: 16),
                    ...cartProvider.items.map(
                      (item) => _buildCheckoutItem(item),
                    ),
                    const Divider(color: Colors.black12),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Choose Shipping'),
                    const SizedBox(height: 16),
                    _buildShippingSelector(context, checkoutProvider),
                    const Divider(color: Colors.black12),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Promo Code'),
                    const SizedBox(height: 16),
                    _buildPromoCodeField(context, checkoutProvider),
                    const SizedBox(height: 24),
                    _buildSummaryCard(cartProvider, checkoutProvider),
                    const SizedBox(height: 120), // Space for bottom bar
                  ],
                ),
              ),
              _buildBottomAction(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildAddressCard(BuildContext context, CheckoutProvider provider) {
    final address = provider.selectedAddress;
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.shippingAddress),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppColors.grey500,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address?.label ?? 'Home',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address?.address ?? 'Add your address',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: AppColors.grey500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.edit, color: Colors.black, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(item.product.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${item.color != null ? "Color | " : ""}${item.size != null ? "Size = ${item.size}" : ""}',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: AppColors.grey500,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${item.product.price}',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: AppColors.grey100,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${item.quantity}',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingSelector(
    BuildContext context,
    CheckoutProvider provider,
  ) {
    final type = provider.selectedShippingType;
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.chooseShipping),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.local_shipping, color: Colors.black),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type?.name ?? 'Choose Shipping Type',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: type != null
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: type != null ? Colors.black : Colors.black54,
                    ),
                  ),
                  if (type != null)
                    Text(
                      type.duration,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: AppColors.grey500,
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoCodeField(BuildContext context, CheckoutProvider provider) {
    final promo = provider.selectedPromo;
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              promo?.title ?? 'Enter Promo Code',
              style: GoogleFonts.outfit(
                color: promo != null ? Colors.black : Colors.black26,
                fontWeight: promo != null ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.addPromo),
          child: Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(CartProvider cart, CheckoutProvider checkout) {
    final subtotal = cart.totalAmount;
    final shipping = checkout.selectedShippingType?.price;
    final promoDiscountP = checkout.selectedPromo?.discountPercent ?? 0;
    final discountAmount = subtotal * (promoDiscountP / 100);
    final total = subtotal + (shipping ?? 0) - discountAmount;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow('Amount', '\$${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 16),
          _buildSummaryRow(
            'Shipping',
            shipping != null ? '\$${shipping.toStringAsFixed(2)}' : '-',
          ),
          if (promoDiscountP > 0) ...[
            const SizedBox(height: 16),
            _buildSummaryRow(
              'Promo',
              '-\$${discountAmount.toStringAsFixed(2)}',
            ),
          ],
          const SizedBox(height: 16),
          const Divider(color: Colors.black12),
          const SizedBox(height: 16),
          _buildSummaryRow(
            'Total',
            '\$${total.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 16,
            color: isTotal ? Colors.black : AppColors.grey500,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: isTotal ? 20 : 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () =>
              Navigator.pushNamed(context, AppRoutes.paymentMethod),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 64),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Continue to Payment',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.arrow_forward_rounded, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
