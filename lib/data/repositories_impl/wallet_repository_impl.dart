import '../../domain/models/wallet_model.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../data_sources/local/wallet_local_data_source.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletLocalDataSource localDataSource;

  WalletRepositoryImpl({required this.localDataSource});

  @override
  WalletCard getWalletCard() => localDataSource.getWalletCard();

  @override
  List<WalletTransaction> getTransactions() =>
      localDataSource.getTransactions();

  @override
  double topUp(double currentBalance, double amount) => currentBalance + amount;
}
