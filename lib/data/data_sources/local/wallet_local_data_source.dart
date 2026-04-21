import '../../../domain/models/wallet_model.dart';

abstract class WalletLocalDataSource {
  WalletCard getWalletCard();
  List<WalletTransaction> getTransactions();
}

class WalletLocalDataSourceImpl implements WalletLocalDataSource {
  @override
  WalletCard getWalletCard() {
    return const WalletCard(
      cardholderName: 'Andrew Ainsley',
      lastDigits: '3629',
      balance: 9379,
      cardNetwork: 'visa',
    );
  }

  @override
  List<WalletTransaction> getTransactions() {
    return [
      WalletTransaction(
        id: '1',
        title: 'Suga Leather Shoes',
        imageUrl:
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=200',
        amount: 262.5,
        type: TransactionType.order,
        date: DateTime(2024, 12, 15, 10, 0),
      ),
      WalletTransaction(
        id: '2',
        title: 'Top Up Wallet',
        imageUrl: '',
        amount: 500,
        type: TransactionType.topUp,
        date: DateTime(2024, 12, 14, 16, 42),
      ),
      WalletTransaction(
        id: '3',
        title: 'Werolla Cardigans',
        imageUrl:
            'https://images.unsplash.com/photo-1554568218-0f1715e72254?w=200',
        amount: 385,
        type: TransactionType.order,
        date: DateTime(2024, 12, 14, 11, 39),
      ),
      WalletTransaction(
        id: '4',
        title: 'Mini Leather Bag',
        imageUrl:
            'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=200',
        amount: 540,
        type: TransactionType.order,
        date: DateTime(2024, 12, 13, 14, 46),
      ),
      WalletTransaction(
        id: '5',
        title: 'Top Up Wallet',
        imageUrl: '',
        amount: 550,
        type: TransactionType.topUp,
        date: DateTime(2024, 12, 12, 9, 27),
      ),
      WalletTransaction(
        id: '6',
        title: 'Vinia Headphone',
        imageUrl:
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=200',
        amount: 360,
        type: TransactionType.order,
        date: DateTime(2024, 12, 11, 13, 15),
      ),
      WalletTransaction(
        id: '7',
        title: 'Top Up Wallet',
        imageUrl: '',
        amount: 1000,
        type: TransactionType.topUp,
        date: DateTime(2024, 12, 10, 8, 0),
      ),
    ];
  }
}
