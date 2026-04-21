import 'package:flutter/material.dart';
import '../../../domain/models/address_model.dart';
import '../../../domain/models/shipping_model.dart';
import '../../../domain/models/promo_model.dart';
import '../../../domain/models/payment_model.dart';

class CheckoutProvider with ChangeNotifier {
  final List<Address> _addresses = [
    Address(
      id: "1",
      label: "Home",
      address: "61480 Sunbrook Park, PC 5679",
      isDefault: true,
    ),
    Address(
      id: "2",
      label: "Office",
      address: "6993 Meadow Valley Terra, PC 3637",
    ),
    Address(
      id: "3",
      label: "Apartment",
      address: "21833 Clyde Gallagher, PC 4662",
    ),
    Address(
      id: "4",
      label: "Parent's House",
      address: "5259 Blue Bill Park, PC 4627",
    ),
  ];

  final List<ShippingType> _shippingTypes = [
    ShippingType(
      id: '1',
      name: 'Economy',
      duration: 'Estimated Arrival, Dec 20-23',
      price: 10.00,
    ),
    ShippingType(
      id: '2',
      name: 'Regular',
      duration: 'Estimated Arrival, Dec 20-22',
      price: 15.00,
    ),
    ShippingType(
      id: '3',
      name: 'Cargo',
      duration: 'Estimated Arrival, Dec 19-20',
      price: 20.00,
    ),
    ShippingType(
      id: '4',
      name: 'Express',
      duration: 'Estimated Arrival, Dec 18-19',
      price: 30.00,
    ),
  ];

  final List<Promo> _promos = [
    Promo(
      id: '1',
      title: 'Special 25% Off',
      subtitle: 'Special promo only today!',
      discountPercent: 25,
    ),
    Promo(
      id: '2',
      title: 'Discount 30% Off',
      subtitle: 'New user special promo',
      discountPercent: 30,
    ),
    Promo(
      id: '3',
      title: 'Special 20% Off',
      subtitle: 'Special promo only today!',
      discountPercent: 20,
    ),
    Promo(
      id: '4',
      title: 'Discount 40% Off',
      subtitle: 'Special promo only valid today!',
      discountPercent: 40,
    ),
    Promo(
      id: '5',
      title: 'Discount 35% Off',
      subtitle: 'Special promo only today!',
      discountPercent: 35,
    ),
  ];

  final List<PaymentMethod> _paymentMethods = [
    PaymentMethod(
      id: '1',
      name: 'My Wallet',
      iconPath: 'wallet',
      type: PaymentType.wallet,
      balance: '\$9,379',
    ),
    PaymentMethod(
      id: '2',
      name: 'PayPal',
      iconPath: 'paypal',
      type: PaymentType.paypal,
    ),
    PaymentMethod(
      id: '3',
      name: 'Google Pay',
      iconPath: 'google',
      type: PaymentType.googlePay,
    ),
    PaymentMethod(
      id: '4',
      name: 'Apple Pay',
      iconPath: 'apple',
      type: PaymentType.applePay,
    ),
    PaymentMethod(
      id: '5',
      name: '.... .... .... 4679',
      iconPath: 'mastercard',
      type: PaymentType.card,
    ),
  ];

  Address? _selectedAddress;
  ShippingType? _selectedShippingType;
  Promo? _selectedPromo;
  PaymentMethod? _selectedPaymentMethod;

  List<Address> get addresses => _addresses;
  List<ShippingType> get shippingTypes => _shippingTypes;
  List<Promo> get promos => _promos;
  List<PaymentMethod> get paymentMethods => _paymentMethods;

  Address? get selectedAddress =>
      _selectedAddress ?? _addresses.firstWhere((a) => a.isDefault);
  ShippingType? get selectedShippingType => _selectedShippingType;
  Promo? get selectedPromo => _selectedPromo;
  PaymentMethod? get selectedPaymentMethod =>
      _selectedPaymentMethod ?? _paymentMethods.first;

  void selectAddress(Address address) {
    _selectedAddress = address;
    notifyListeners();
  }

  void selectShippingType(ShippingType type) {
    _selectedShippingType = type;
    notifyListeners();
  }

  void selectPromo(Promo promo) {
    _selectedPromo = promo;
    notifyListeners();
  }

  void selectPaymentMethod(PaymentMethod method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }
}
