import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../state_managements/providers/wallet_provider.dart';
import '../../../domain/models/wallet_model.dart';
import '../../../domain/models/order_model.dart';
import '../../../config/router/app_router.dart';
import '../../../utils/constants/app_constants.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Consumer<WalletProvider>(
        builder: (context, provider, _) {
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 8),
                    _WalletCard(
                      provider: provider,
                      onTopUp: () =>
                          Navigator.pushNamed(context, AppRoutes.walletTopUp),
                    ),
                    const SizedBox(height: 32),
                    _buildTransactionHeader(context),
                    const SizedBox(height: 16),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final tx = provider.transactions[index];
                    return _TransactionTile(
                      transaction: tx,
                      isLast: index == provider.transactions.length - 1,
                    );
                  }, childCount: provider.transactions.length),
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
            ],
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 24,
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'My E-Wallet',
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.more_horiz, color: Colors.black),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildTransactionHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Transaction History',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.allTransactions),
          child: Text(
            'See All',
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Wallet Card Widget
// ─────────────────────────────────────────────

class _WalletCard extends StatelessWidget {
  final WalletProvider provider;
  final VoidCallback onTopUp;

  const _WalletCard({required this.provider, required this.onTopUp});

  @override
  Widget build(BuildContext context) {
    final card = provider.card;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle geometric pattern overlay
          Positioned.fill(child: _CardPattern()),
          // Card content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardHeader(card),
              const SizedBox(height: 24),
              Text(
                'Your balance',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: Colors.white54,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    provider.formattedBalance,
                    style: GoogleFonts.outfit(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  _TopUpButton(onTap: onTopUp),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardHeader(WalletCard card) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              card.cardholderName,
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '•••• •••• •••• ${card.lastDigits}',
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: Colors.white70,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        _CardNetworkBadge(),
      ],
    );
  }
}

class _TopUpButton extends StatelessWidget {
  final VoidCallback onTap;

  const _TopUpButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.account_balance_wallet_outlined,
              color: Colors.black,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'Top Up',
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardNetworkBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'VISA',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(width: 8),
        Stack(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            Positioned(
              left: 14,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.85),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CardPattern extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: CustomPaint(painter: _HexPatternPainter()),
    );
  }
}

class _HexPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..style = PaintingStyle.fill;

    const double r = 28;
    const double h = r * 1.732;

    for (double y = -h; y < size.height + h; y += h) {
      for (double x = -r; x < size.width + r; x += r * 3) {
        _drawHex(canvas, paint, Offset(x, y), r);
        _drawHex(canvas, paint, Offset(x + r * 1.5, y + h / 2), r);
      }
    }
  }

  void _drawHex(Canvas canvas, Paint paint, Offset center, double r) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (60 * i - 30) * (3.14159 / 180);
      final x = center.dx + r * cos(angle);
      final y = center.dy + r * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  double cos(double a) => _cos(a);
  double sin(double a) => _sin(a);

  double _cos(double a) {
    // Simple Taylor approximation for small angles; use dart:math in practice
    return _mathCos(a);
  }

  double _sin(double a) {
    return _mathSin(a);
  }

  double _mathCos(double x) {
    x = x % (2 * 3.14159265358979);
    double result = 1;
    double term = 1;
    for (int i = 1; i <= 10; i++) {
      term *= -x * x / ((2 * i - 1) * (2 * i));
      result += term;
    }
    return result;
  }

  double _mathSin(double x) {
    x = x % (2 * 3.14159265358979);
    double result = x;
    double term = x;
    for (int i = 1; i <= 10; i++) {
      term *= -x * x / ((2 * i) * (2 * i + 1));
      result += term;
    }
    return result;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────
// Transaction Tile Widget
// ─────────────────────────────────────────────

class _TransactionTile extends StatelessWidget {
  final WalletTransaction transaction;
  final bool isLast;

  const _TransactionTile({required this.transaction, this.isLast = false});

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
      child: Container(
        margin: EdgeInsets.only(bottom: isLast ? 0 : 20),
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            _buildAvatar(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    transaction.formattedDate,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: AppColors.grey500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${transaction.amount.toStringAsFixed(transaction.amount == transaction.amount.truncate() ? 0 : 1)}',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                _buildTypeBadge(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final isTopUp = transaction.type == TransactionType.topUp;

    if (isTopUp) {
      return Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.account_balance_wallet_outlined,
          color: Colors.white,
          size: 26,
        ),
      );
    }

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.grey100,
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      child: transaction.imageUrl.isNotEmpty
          ? Image.network(
              transaction.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.black54,
              ),
            )
          : const Icon(Icons.shopping_bag_outlined, color: Colors.black54),
    );
  }

  Widget _buildTypeBadge() {
    final isTopUp = transaction.type == TransactionType.topUp;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isTopUp
            ? const Color(0xFF2196F3).withValues(alpha: 0.12)
            : const Color(0xFFE53935).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isTopUp ? 'Top Up' : 'Orders',
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isTopUp
                  ? const Color(0xFF1565C0)
                  : const Color(0xFFC62828),
            ),
          ),
          const SizedBox(width: 3),
          Icon(
            isTopUp ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
            size: 11,
            color: isTopUp ? const Color(0xFF1565C0) : const Color(0xFFC62828),
          ),
        ],
      ),
    );
  }
}
