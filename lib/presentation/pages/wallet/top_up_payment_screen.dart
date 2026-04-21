import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../state_managements/providers/checkout_provider.dart';
import '../../state_managements/providers/wallet_provider.dart';
import '../../../domain/models/payment_model.dart';

class TopUpPaymentScreen extends StatefulWidget {
  final double amount;

  const TopUpPaymentScreen({super.key, required this.amount});

  @override
  State<TopUpPaymentScreen> createState() => _TopUpPaymentScreenState();
}

class _TopUpPaymentScreenState extends State<TopUpPaymentScreen>
    with SingleTickerProviderStateMixin {
  PaymentMethod? _selectedMethod;
  Future<void> _onContinue() async {
    Navigator.pushNamed(context, '/top-up-pin', arguments: widget.amount);
  }

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
          'Top Up E-Wallet',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
      ),
      body: Consumer2<CheckoutProvider, WalletProvider>(
        builder: (context, checkoutProvider, walletProvider, child) {
          final topUpMethods = checkoutProvider.paymentMethods
              .where((m) => m.type != PaymentType.wallet)
              .toList();

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      'Select the top up method you want to use.',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ...topUpMethods.map((method) => _buildPaymentItem(method)),
                    _buildAddNewCardButton(),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
              _buildContinueButton(walletProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPaymentItem(PaymentMethod method) {
    bool isSelected = _selectedMethod?.id == method.id;

    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = method),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildMethodIcon(method),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                method.name,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.black26,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodIcon(PaymentMethod method) {
    switch (method.type) {
      case PaymentType.paypal:
        return const Icon(Icons.payment, color: Color(0xFF003087), size: 30);
      case PaymentType.googlePay:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 5, height: 16, color: const Color(0xFF4285F4)),
            const SizedBox(width: 2),
            Container(width: 5, height: 16, color: const Color(0xFFEA4335)),
            const SizedBox(width: 2),
            Container(width: 5, height: 16, color: const Color(0xFFFBBC05)),
            const SizedBox(width: 2),
            Container(width: 5, height: 16, color: const Color(0xFF34A853)),
          ],
        );
      case PaymentType.applePay:
        return const Icon(Icons.apple, color: Colors.black, size: 34);
      case PaymentType.card:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                color: Color(0xFFEB001B),
                shape: BoxShape.circle,
              ),
            ),
            Transform.translate(
              offset: const Offset(-8, 0),
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: const Color(0xFFF79E1B).withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        );
      default:
        return const Icon(Icons.payment, color: Colors.black, size: 28);
    }
  }

  Widget _buildAddNewCardButton() {
    return Container(
      width: double.infinity,
      height: 60,
      margin: const EdgeInsets.only(top: 8),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEFEFEF),
          foregroundColor: Colors.black87,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          'Add New Card',
          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildContinueButton(WalletProvider provider) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _selectedMethod == null || provider.isLoading
              ? null
              : _onContinue,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF131313),
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey[400],
            disabledForegroundColor: Colors.white70,
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          child: provider.isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  'Continue',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
