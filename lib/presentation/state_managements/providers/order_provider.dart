import 'package:flutter/material.dart';
import '../../../domain/models/order_model.dart';

class OrderProvider with ChangeNotifier {
  final List<OrderItem> _ongoingOrders = [
    OrderItem(
      id: '1',
      productName: 'Suga Leather Shoes',
      image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
      price: 375.00,
      color: '#8B4513',
      size: '40',
      quantity: 1,
      status: OrderStatus.inDelivery,
      trackingSteps: [
        TrackingStep(
          title: 'Order In Transit - Dec 17',
          address: '32 Manchester Ave. Ringgold, GA 30736',
          time: '15:20 PM',
          stepStatus: TrackingStepStatus.current,
        ),
        TrackingStep(
          title: 'Order ... Customs Port - Dec 16',
          address: '4 Evergreen Street Lake Zurich, IL 60047',
          time: '14:40 PM',
          stepStatus: TrackingStepStatus.completed,
        ),
        TrackingStep(
          title: 'Orders are ... Shipped - Dec 15',
          address: '9177 Hillcrest Street Wheeling, WV 26003',
          time: '11:30 AM',
          stepStatus: TrackingStepStatus.completed,
        ),
        TrackingStep(
          title: 'Order is in Packing - Dec 15',
          address: '891 Glen Ridge St. Gainesville, VA 20155',
          time: '10:25 AM',
          stepStatus: TrackingStepStatus.completed,
        ),
        TrackingStep(
          title: 'Verified Payments - Dec 15',
          address: '55 Summerhouse Dr. Apopka, FL 32703',
          time: '10:04 AM',
          stepStatus: TrackingStepStatus.completed,
        ),
      ],
    ),
    OrderItem(
      id: '2',
      productName: 'Werolla Cardigans',
      image: 'https://images.unsplash.com/photo-1554568218-0f1715e72254?w=400',
      price: 385.00,
      color: '#808080',
      size: 'M',
      quantity: 1,
      status: OrderStatus.inDelivery,
      trackingSteps: [
        TrackingStep(
          title: 'Order In Transit - Dec 17',
          address: '14 Oak Lane Chicago, IL 60601',
          time: '09:15 AM',
          stepStatus: TrackingStepStatus.current,
        ),
        TrackingStep(
          title: 'Orders are Shipped - Dec 16',
          address: '22 Maple Ave. Seattle, WA 98101',
          time: '02:30 PM',
          stepStatus: TrackingStepStatus.completed,
        ),
        TrackingStep(
          title: 'Verified Payments - Dec 15',
          address: '88 Commerce Blvd Austin, TX 78701',
          time: '08:45 AM',
          stepStatus: TrackingStepStatus.completed,
        ),
      ],
    ),
    OrderItem(
      id: '3',
      productName: 'Vinia Headphone',
      image:
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
      price: 360.00,
      color: '#000000',
      quantity: 1,
      status: OrderStatus.inDelivery,
      trackingSteps: [
        TrackingStep(
          title: 'Order In Transit - Dec 18',
          address: '5 Harbor St. Miami, FL 33101',
          time: '11:00 AM',
          stepStatus: TrackingStepStatus.current,
        ),
        TrackingStep(
          title: 'Orders Shipped - Dec 17',
          address: '19 Sunrise Dr. Denver, CO 80203',
          time: '03:20 PM',
          stepStatus: TrackingStepStatus.completed,
        ),
        TrackingStep(
          title: 'Order in Packing - Dec 16',
          address: '77 Ridgeway Ave. Portland, OR 97201',
          time: '10:10 AM',
          stepStatus: TrackingStepStatus.completed,
        ),
        TrackingStep(
          title: 'Verified Payments - Dec 15',
          address: '41 West End Lane Boston, MA 02101',
          time: '09:30 AM',
          stepStatus: TrackingStepStatus.completed,
        ),
      ],
    ),
    OrderItem(
      id: '4',
      productName: 'Zonio Super Watch',
      image:
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
      price: 299.00,
      color: '#C0C0C0',
      quantity: 1,
      status: OrderStatus.inDelivery,
      trackingSteps: [
        TrackingStep(
          title: 'Order Shipped - Dec 17',
          address: '9 Lakeside Blvd. Nashville, TN 37201',
          time: '01:55 PM',
          stepStatus: TrackingStepStatus.current,
        ),
        TrackingStep(
          title: 'Order in Packing - Dec 16',
          address: '33 Pinecrest Rd. Phoenix, AZ 85001',
          time: '08:00 AM',
          stepStatus: TrackingStepStatus.completed,
        ),
        TrackingStep(
          title: 'Verified Payments - Dec 15',
          address: '102 Valley View Houston, TX 77001',
          time: '04:45 PM',
          stepStatus: TrackingStepStatus.completed,
        ),
      ],
    ),
  ];

  final List<OrderItem> _completedOrders = [
    OrderItem(
      id: '5',
      productName: 'Casual White Sneakers',
      image:
          'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?w=400',
      price: 220.00,
      color: '#FFFFFF',
      size: '42',
      quantity: 1,
      status: OrderStatus.delivered,
    ),
    OrderItem(
      id: '6',
      productName: 'Slim Fit Jeans',
      image: 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=400',
      price: 155.00,
      color: '#1E3A5F',
      size: 'L',
      quantity: 2,
      status: OrderStatus.delivered,
    ),
    OrderItem(
      id: '7',
      productName: 'Leather Handbag',
      image: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400',
      price: 410.00,
      color: '#3B2F2F',
      quantity: 1,
      status: OrderStatus.delivered,
    ),
  ];

  List<OrderItem> get ongoingOrders => _ongoingOrders;
  List<OrderItem> get completedOrders => _completedOrders;
}
