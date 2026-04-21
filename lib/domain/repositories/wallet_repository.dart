import '../../domain/models/wallet_model.dart';

abstract class WalletRepository {
  WalletCard getWalletCard();
  List<WalletTransaction> getTransactions();
  double topUp(double currentBalance, double amount);
}
