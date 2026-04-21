enum OrderStatus { inDelivery, delivered, cancelled }

enum TrackingStepStatus { completed, current, pending }

class TrackingStep {
  final String title;
  final String address;
  final String time;
  final TrackingStepStatus stepStatus;

  TrackingStep({
    required this.title,
    required this.address,
    required this.time,
    required this.stepStatus,
  });
}

class OrderItem {
  final String id;
  final String productName;
  final String image;
  final double price;
  final String? color;
  final String? size;
  final int quantity;
  final OrderStatus status;
  final List<TrackingStep> trackingSteps;

  OrderItem({
    required this.id,
    required this.productName,
    required this.image,
    required this.price,
    this.color,
    this.size,
    required this.quantity,
    required this.status,
    this.trackingSteps = const [],
  });

  String get statusLabel {
    switch (status) {
      case OrderStatus.inDelivery:
        return 'In Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  // Current delivery stage index (0-3): Packed, Shipped, In Transit, Delivered
  int get deliveryStage {
    if (status == OrderStatus.delivered) return 3;
    // Based on tracking steps with 'completed' or 'current' status
    final completedOrCurrent = trackingSteps
        .where(
          (s) =>
              s.stepStatus == TrackingStepStatus.completed ||
              s.stepStatus == TrackingStepStatus.current,
        )
        .length;
    if (completedOrCurrent >= 4) return 3;
    if (completedOrCurrent >= 3) return 2;
    if (completedOrCurrent >= 2) return 1;
    return 0;
  }
}
