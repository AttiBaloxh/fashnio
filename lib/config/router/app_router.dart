import 'package:flutter/material.dart';
import '../../presentation/pages/main_screen.dart';
import '../../presentation/pages/notification/notification_screen.dart';
import '../../presentation/pages/wishlist/wishlist_screen.dart';
import '../../presentation/pages/product/product_details_screen.dart';
import '../../presentation/pages/product/popular_products_screen.dart';
import '../../presentation/pages/product/category_products_screen.dart';
import '../../presentation/pages/review/review_screen.dart';
import '../../presentation/pages/checkout/checkout_screen.dart';
import '../../presentation/pages/checkout/shipping_address_screen.dart';
import '../../presentation/pages/checkout/choose_shipping_screen.dart';
import '../../presentation/pages/checkout/add_promo_screen.dart';
import '../../presentation/pages/checkout/payment_method_screen.dart';
import '../../presentation/pages/checkout/enter_pin_screen.dart';
import '../../presentation/pages/orders/track_order_screen.dart';
import '../../presentation/pages/orders/e_receipt_screen.dart';
import '../../presentation/pages/wallet/top_up_screen.dart';
import '../../presentation/pages/wallet/top_up_payment_screen.dart';
import '../../presentation/pages/wallet/top_up_pin_screen.dart';
import '../../presentation/pages/wallet/all_transactions_screen.dart';
import '../../domain/models/home_models.dart';
import '../../domain/models/order_model.dart';

class AppRoutes {
  static const String home = '/';
  static const String notification = '/notification';
  static const String wishlist = '/wishlist';
  static const String productDetails = '/product-details';
  static const String popularProducts = '/popular-products';
  static const String categoryProducts = '/category-products';
  static const String reviews = '/reviews';
  static const String checkout = '/checkout';
  static const String shippingAddress = '/shipping-address';
  static const String chooseShipping = '/choose-shipping';
  static const String addPromo = '/add-promo';
  static const String paymentMethod = '/payment-method';
  static const String enterPin = '/enter-pin';
  static const String trackOrder = '/track-order';
  static const String eReceipt = '/e-receipt';
  static const String walletTopUp = '/wallet-top-up';
  static const String topUpPayment = '/top-up-payment';
  static const String topUpPin = '/top-up-pin';
  static const String allTransactions = '/all-transactions';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case notification:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());
      case wishlist:
        return MaterialPageRoute(builder: (_) => const WishlistScreen());
      case popularProducts:
        return MaterialPageRoute(builder: (_) => const PopularProductsScreen());
      case categoryProducts:
        final categoryName = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => CategoryProductsScreen(categoryName: categoryName),
        );
      case productDetails:
        final product = settings.arguments as Product;
        return MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(product: product),
        );
      case reviews:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ReviewScreen(
            rating: args['rating'],
            reviewsCount: args['reviewsCount'],
          ),
        );
      case checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutScreen());
      case shippingAddress:
        return MaterialPageRoute(builder: (_) => const ShippingAddressScreen());
      case chooseShipping:
        return MaterialPageRoute(builder: (_) => const ChooseShippingScreen());
      case addPromo:
        return MaterialPageRoute(builder: (_) => const AddPromoScreen());
      case paymentMethod:
        return MaterialPageRoute(builder: (_) => const PaymentMethodScreen());
      case enterPin:
        return MaterialPageRoute(builder: (_) => const EnterPinScreen());
      case trackOrder:
        final order = settings.arguments as OrderItem;
        return MaterialPageRoute(
          builder: (_) => TrackOrderScreen(order: order),
        );
      case eReceipt:
        final order = settings.arguments as OrderItem;
        return MaterialPageRoute(builder: (_) => EReceiptScreen(order: order));
      case walletTopUp:
        return MaterialPageRoute(builder: (_) => const TopUpScreen());
      case topUpPayment:
        final amount = settings.arguments as double;
        return MaterialPageRoute(
          builder: (_) => TopUpPaymentScreen(amount: amount),
        );
      case topUpPin:
        final amount = settings.arguments as double;
        return MaterialPageRoute(
          builder: (_) => TopUpPinScreen(amount: amount),
        );
      case allTransactions:
        return MaterialPageRoute(builder: (_) => const AllTransactionsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
