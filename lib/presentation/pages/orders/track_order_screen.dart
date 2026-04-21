import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/models/order_model.dart';
import '../../../utils/constants/app_constants.dart';

class TrackOrderScreen extends StatelessWidget {
  final OrderItem order;

  const TrackOrderScreen({super.key, required this.order});

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
          'Track Order',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductCard(),
            const SizedBox(height: 28),
            _buildDeliveryStages(),
            const SizedBox(height: 28),
            _buildStatusDetailsHeader(),
            const SizedBox(height: 20),
            _buildTrackingTimeline(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ───────────────── Product summary card ───────────────────
  Widget _buildProductCard() {
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
          Container(
            width: 90,
            height: 100,
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
                const SizedBox(height: 8),
                // Color + Size + Qty row
                Row(
                  children: [
                    if (order.color != null) ...[
                      _colorDot(order.color!),
                      const SizedBox(width: 6),
                      Text('Color', style: _metaStyle()),
                      _pipe(),
                    ],
                    if (order.size != null) ...[
                      Text('Size = ${order.size}', style: _metaStyle()),
                      _pipe(),
                    ],
                    Text('Qty = ${order.quantity}', style: _metaStyle()),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '\$${order.price.toStringAsFixed(2)}',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
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

  // ───────────────── Delivery stage stepper ─────────────────
  Widget _buildDeliveryStages() {
    final stages = [
      {'icon': Icons.inventory_2_outlined, 'label': 'Packed'},
      {'icon': Icons.local_shipping_outlined, 'label': 'Shipped'},
      {'icon': Icons.people_outline, 'label': 'In Transit'},
      {'icon': Icons.unarchive_outlined, 'label': 'Delivered'},
    ];

    final activeStage = order.deliveryStage;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
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
      child: Column(
        children: [
          Row(
            children: List.generate(stages.length * 2 - 1, (i) {
              if (i.isOdd) {
                // Dashed connector
                final connectorIndex = i ~/ 2;
                final passed = connectorIndex < activeStage;
                return Expanded(child: _dashedLine(active: passed));
              }
              final stageIndex = i ~/ 2;
              final isCompleted = stageIndex < activeStage;
              final isCurrent = stageIndex == activeStage;
              return _stageIcon(
                icon: stages[stageIndex]['icon'] as IconData,
                isCompleted: isCompleted,
                isCurrent: isCurrent,
              );
            }),
          ),
          const SizedBox(height: 16),
          Text(
            _currentStageName(activeStage),
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _currentStageName(int stage) {
    switch (stage) {
      case 0:
        return 'Packet in Packing';
      case 1:
        return 'Packet Shipped';
      case 2:
        return 'Packet In Delivery';
      case 3:
        return 'Packet Delivered';
      default:
        return 'Packet In Delivery';
    }
  }

  Widget _stageIcon({
    required IconData icon,
    required bool isCompleted,
    required bool isCurrent,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 28,
          color: (isCompleted || isCurrent) ? Colors.black : Colors.black26,
        ),
        const SizedBox(height: 8),
        if (isCompleted)
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 14),
          )
        else
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isCurrent ? Colors.black : Colors.black26,
                width: 2,
              ),
            ),
            child: isCurrent
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
      ],
    );
  }

  Widget _dashedLine({required bool active}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashCount = (constraints.maxWidth / 8).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(dashCount, (_) {
            return Container(
              width: 4,
              height: 2,
              color: active ? Colors.black : Colors.black26,
            );
          }),
        );
      },
    );
  }

  // ───────────────── Tracking timeline ──────────────────────
  Widget _buildStatusDetailsHeader() {
    return Text(
      'Order Status Details',
      style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTrackingTimeline() {
    final steps = order.trackingSteps;
    if (steps.isEmpty) {
      return Center(
        child: Text(
          'No tracking information yet.',
          style: GoogleFonts.outfit(color: AppColors.grey500),
        ),
      );
    }

    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;
        return _buildTimelineItem(step, isLast: isLast);
      }),
    );
  }

  Widget _buildTimelineItem(TrackingStep step, {required bool isLast}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: dot + dashed line
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: Colors.black12,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Right: details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 28),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.title,
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          step.address,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            color: AppColors.grey500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    step.time,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: AppColors.grey500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────── Helpers ────────────────────────────────
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
