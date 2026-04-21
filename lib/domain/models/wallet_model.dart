enum TransactionType { order, topUp }

class WalletTransaction {
  final String id;
  final String title;
  final String imageUrl;
  final double amount;
  final TransactionType type;
  final DateTime date;

  const WalletTransaction({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.amount,
    required this.type,
    required this.date,
  });

  bool get isDebit => type == TransactionType.order;

  String get formattedDate {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final m = months[date.month - 1];
    final d = date.day;
    final y = date.year;
    final min = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final h12 = date.hour > 12
        ? date.hour - 12
        : (date.hour == 0 ? 12 : date.hour);
    return '$m $d, $y | ${h12.toString().padLeft(2, '0')}:$min $period';
  }

  String get formattedAmount {
    final prefix = isDebit ? '-' : '+';
    return '$prefix\$${amount.toStringAsFixed(1)}';
  }
}

class WalletCard {
  final String cardholderName;
  final String lastDigits;
  final double balance;
  final String cardNetwork; // 'visa', 'mastercard'

  const WalletCard({
    required this.cardholderName,
    required this.lastDigits,
    required this.balance,
    required this.cardNetwork,
  });

  String get maskedNumber => '•••• •••• •••• $lastDigits';

  String get formattedBalance {
    final int whole = balance.truncate().toInt();
    final String formatted = whole.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
    return '\$$formatted';
  }
}
