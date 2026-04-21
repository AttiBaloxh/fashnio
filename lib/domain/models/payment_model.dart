enum PaymentType { wallet, paypal, googlePay, applePay, card }

class PaymentMethod {
  final String id;
  final String name;
  final String iconPath;
  final PaymentType type;
  final String? balance;
  final String? lastDigits;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.iconPath,
    required this.type,
    this.balance,
    this.lastDigits,
  });
}
