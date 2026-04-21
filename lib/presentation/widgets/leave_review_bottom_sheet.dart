import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/models/order_model.dart';
import '../../../utils/constants/app_constants.dart';

class LeaveReviewBottomSheet extends StatefulWidget {
  final OrderItem order;

  const LeaveReviewBottomSheet({super.key, required this.order});

  /// Convenience method to open the sheet
  static Future<void> show(BuildContext context, OrderItem order) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LeaveReviewBottomSheet(order: order),
    );
  }

  @override
  State<LeaveReviewBottomSheet> createState() => _LeaveReviewBottomSheetState();
}

class _LeaveReviewBottomSheetState extends State<LeaveReviewBottomSheet> {
  int _rating = 4;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 8,
        bottom: bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildGrabber(),
          const SizedBox(height: 20),
          _buildHeader(),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Colors.black12),
          const SizedBox(height: 20),
          _buildProductCard(),
          const SizedBox(height: 28),
          _buildRatingSection(),
          const SizedBox(height: 20),
          _buildReviewInput(),
          const SizedBox(height: 4),
          const Divider(height: 24, color: Colors.black12),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  // ─── Grabber ───────────────────────────────────────────────
  Widget _buildGrabber() {
    return Container(
      width: 48,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  // ─── Header ────────────────────────────────────────────────
  Widget _buildHeader() {
    return Text(
      'Leave a Review',
      style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  // ─── Product mini-card ─────────────────────────────────────
  Widget _buildProductCard() {
    final order = widget.order;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product image
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(order.image),
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
                  order.productName,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                // Color dot + meta row
                Row(
                  children: [
                    if (order.color != null) ...[
                      _colorDot(order.color!),
                      const SizedBox(width: 6),
                      Text('Color', style: _metaStyle()),
                      _pipe(),
                    ],
                    Text('Qty = ${order.quantity}', style: _metaStyle()),
                  ],
                ),
                const SizedBox(height: 8),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    order.statusLabel,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${order.price.toStringAsFixed(2)}',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Star rating ───────────────────────────────────────────
  Widget _buildRatingSection() {
    return Column(
      children: [
        Text(
          'How is your order?',
          style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          'Please give your rating & also your review...',
          style: GoogleFonts.outfit(fontSize: 14, color: AppColors.grey500),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final filled = index < _rating;
            return GestureDetector(
              onTap: () => setState(() => _rating = index + 1),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                  filled ? Icons.star : Icons.star_border,
                  color: Colors.black,
                  size: 40,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ─── Text input ────────────────────────────────────────────
  Widget _buildReviewInput() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _reviewController,
              maxLines: 1,
              style: GoogleFonts.outfit(fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Very good product & fast delivery!',
                hintStyle: GoogleFonts.outfit(color: Colors.black26),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Icon(Icons.image_outlined, color: Colors.black54, size: 24),
          ),
        ],
      ),
    );
  }

  // ─── Cancel / Submit ───────────────────────────────────────
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.grey100,
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 60),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              'Cancel',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  content: Text(
                    'Review submitted! Thank you.',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 60),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              'Submit',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Helpers ───────────────────────────────────────────────
  TextStyle _metaStyle() =>
      GoogleFonts.outfit(fontSize: 12, color: AppColors.grey500);

  Widget _pipe() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: Text(
      '|',
      style: GoogleFonts.outfit(fontSize: 12, color: AppColors.grey500),
    ),
  );

  Widget _colorDot(String hexColor) {
    Color color;
    try {
      color = Color(
        int.parse('FF${hexColor.replaceFirst('#', '')}', radix: 16),
      );
    } catch (_) {
      color = Colors.grey;
    }
    return Container(
      width: 13,
      height: 13,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black12, width: 0.5),
      ),
    );
  }
}
