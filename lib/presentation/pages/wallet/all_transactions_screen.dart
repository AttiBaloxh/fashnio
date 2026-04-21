import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../state_managements/providers/wallet_provider.dart';
import '../../../domain/models/wallet_model.dart';
import '../../../domain/models/order_model.dart';
import '../../../config/router/app_router.dart';

class AllTransactionsScreen extends StatefulWidget {
  const AllTransactionsScreen({super.key});

  @override
  State<AllTransactionsScreen> createState() => _AllTransactionsScreenState();
}

class _AllTransactionsScreenState extends State<AllTransactionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
              onPressed: () => Navigator.pop(context),
            );
          },
        ),
        title: Text(
          'Transaction History',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black, size: 28),
            onPressed: () {
              // Open search
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<WalletProvider>(
        builder: (context, provider, _) {
          final filtered = provider.transactions;

          if (filtered.isEmpty) {
            return _buildEmpty();
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              return _TransactionCard(transaction: filtered[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.receipt_long_outlined,
            size: 56,
            color: Colors.black26,
          ),
          const SizedBox(height: 16),
          Text(
            'No transactions found',
            style: GoogleFonts.outfit(
              fontSize: 18,
              color: Colors.black38,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final WalletTransaction transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isTopUp = transaction.type == TransactionType.topUp;
    return InkWell(
      onTap: () {
        if (!isTopUp) {
          final orderMock = OrderItem(
            id: transaction.id,
            productName: transaction.title,
            image: transaction.imageUrl,
            price: transaction.amount,
            quantity: 1,
            status: OrderStatus.delivered,
            color: 'brown',
            size: '40',
          );
          Navigator.pushNamed(
            context,
            AppRoutes.eReceipt,
            arguments: orderMock,
          );
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAvatar(isTopUp),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction.formattedDate,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${transaction.amount.toStringAsFixed(transaction.amount == transaction.amount.truncate() ? 0 : 1)}',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                _buildTypeLabel(isTopUp),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeLabel(bool isTopUp) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isTopUp ? 'Top Up ' : 'Orders ',
          style: GoogleFonts.outfit(fontSize: 12, color: Colors.black54),
        ),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: isTopUp ? const Color(0xFF2962FF) : const Color(0xFFEF5350),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            isTopUp ? Icons.arrow_downward : Icons.arrow_upward,
            size: 10,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(bool isTopUp) {
    if (isTopUp) {
      return Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: Color(0xFFF2F2F2),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF212121),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.account_balance_wallet_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      );
    }
    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        color: Color(0xFFF2F2F2),
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      child: transaction.imageUrl.isNotEmpty
          ? Image.network(
              transaction.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.black38,
              ),
            )
          : const Icon(Icons.shopping_bag_outlined, color: Colors.black38),
    );
  }
}
