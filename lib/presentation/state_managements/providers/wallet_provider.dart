import 'package:flutter/material.dart';
import '../../../domain/models/wallet_model.dart';
import '../../../domain/repositories/wallet_repository.dart';

class WalletProvider with ChangeNotifier {
  final WalletRepository _repository;

  WalletProvider({required WalletRepository repository})
    : _repository = repository {
    _loadData();
  }

  late WalletCard _card;
  late List<WalletTransaction> _transactions;
  double _balance = 0;
  bool _isLoading = false;

  WalletCard get card => _card;
  List<WalletTransaction> get transactions => _transactions;
  double get balance => _balance;
  bool get isLoading => _isLoading;

  String get formattedBalance {
    final int whole = _balance.truncate().toInt();
    final String formatted = whole.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
    return '\$$formatted';
  }

  void _loadData() {
    _card = _repository.getWalletCard();
    _balance = _card.balance;
    _transactions = _repository.getTransactions();
  }

  /// Simulates topping up the wallet with [amount].
  /// Adds a new transaction record and updates the balance.
  Future<void> topUp(double amount) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    _balance = _repository.topUp(_balance, amount);

    final newTransaction = WalletTransaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Top Up Wallet',
      imageUrl: '',
      amount: amount,
      type: TransactionType.topUp,
      date: DateTime.now(),
    );

    _transactions = [newTransaction, ..._transactions];

    _isLoading = false;
    notifyListeners();
  }
}
