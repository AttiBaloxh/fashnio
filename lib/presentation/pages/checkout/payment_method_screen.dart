import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../state_managements/providers/checkout_provider.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../domain/models/payment_model.dart';
import '../../../config/router/app_router.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  PaymentMethod? _tempSelectedMethod;

  @override
  void initState() {
    super.initState();
    _tempSelectedMethod = context
        .read<CheckoutProvider>()
        .selectedPaymentMethod;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Payment Methods',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<CheckoutProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      'Select the payment method you want to use.',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        color: AppColors.grey500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ...provider.paymentMethods.map(
                      (method) => _buildPaymentItem(method),
                    ),
                    const SizedBox(height: 120), // Space for bottom bar
                  ],
                ),
              ),
              _buildConfirmButton(provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPaymentItem(PaymentMethod method) {
    bool isSelected = _tempSelectedMethod?.id == method.id;

    return GestureDetector(
      onTap: () => setState(() => _tempSelectedMethod = method),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildMethodIcon(method),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                method.name,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (method.balance != null)
              Text(
                method.balance!,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(width: 16),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
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
      case PaymentType.wallet:
        return const Icon(
          Icons.account_balance_wallet,
          color: Colors.black,
          size: 28,
        );
      case PaymentType.paypal:
        return const Icon(Icons.payment, color: Colors.blue, size: 28);
      case PaymentType.googlePay:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 4, height: 16, color: Colors.blue),
            const SizedBox(width: 2),
            Container(width: 4, height: 16, color: Colors.red),
            const SizedBox(width: 2),
            Container(width: 4, height: 16, color: Colors.yellow),
            const SizedBox(width: 2),
            Container(width: 4, height: 16, color: Colors.green),
          ],
        );
      case PaymentType.applePay:
        return const Icon(Icons.apple, color: Colors.black, size: 32);
      case PaymentType.card:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            Transform.translate(
              offset: const Offset(-10, 0),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        );
    }
  }

  Widget _buildConfirmButton(CheckoutProvider provider) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _tempSelectedMethod == null
              ? null
              : () {
                  provider.selectPaymentMethod(_tempSelectedMethod!);
                  Navigator.pushNamed(context, AppRoutes.enterPin);
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey[300],
            minimumSize: const Size(double.infinity, 64),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          child: Text(
            'Confirm Payment',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
