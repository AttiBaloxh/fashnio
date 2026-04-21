import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../state_managements/providers/cart_provider.dart';
import '../../../domain/models/order_model.dart';
import '../../../config/router/app_router.dart';

class EnterPinScreen extends StatefulWidget {
  const EnterPinScreen({super.key});

  @override
  State<EnterPinScreen> createState() => _EnterPinScreenState();
}

class _EnterPinScreenState extends State<EnterPinScreen> {
  String _pin = "";

  void _onKeyPress(String value) {
    if (_pin.length < 4) {
      setState(() {
        _pin += value;
      });
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void _confirmPayment() {
    if (_pin.length == 4) {
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 40),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSuccessIcon(),
                const SizedBox(height: 32),
                Text(
                  'Order Successful!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'You have successfully made order',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.home,
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 64),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'View Order',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    final cart = context.read<CartProvider>();
                    OrderItem orderMock;
                    if (cart.items.isNotEmpty) {
                      final item = cart.items.first;
                      orderMock = OrderItem(
                        id: 'ORD${DateTime.now().millisecondsSinceEpoch}',
                        productName: cart.items.length > 1
                            ? '${item.product.name} (+${cart.items.length - 1})'
                            : item.product.name,
                        image: item.product.image,
                        price: cart.totalAmount,
                        quantity: 1,
                        status: OrderStatus.delivered,
                        color: item.color?.toString(),
                        size: item.size,
                      );
                    } else {
                      orderMock = OrderItem(
                        id: 'MOCK123',
                        productName: 'Store Purchase',
                        image: '',
                        price: 0,
                        quantity: 1,
                        status: OrderStatus.delivered,
                      );
                    }
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.eReceipt,
                      (route) => route.settings.name == AppRoutes.home,
                      arguments: orderMock,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEEEEEE),
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 64),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'View E-Receipt',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuccessIcon() {
    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Dots background pattern
          Positioned(top: 10, left: 30, child: _dot(8)),
          Positioned(top: 5, right: 40, child: _dot(5)),
          Positioned(top: 40, left: 10, child: _dot(4)),
          Positioned(top: 50, right: 5, child: _dot(6)),
          Positioned(bottom: 20, left: 20, child: _dot(6)),
          Positioned(bottom: 10, right: 30, child: _dot(5)),
          Positioned(bottom: 40, right: 10, child: _dot(4)),
          Positioned(left: 0, top: 80, child: _dot(7)),

          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
              size: 40,
            ),
          ),
          // Small minus/dash inside cart (approximation)
          Positioned(
            child: Container(
              width: 12,
              height: 3,
              margin: const EdgeInsets.only(left: 8, top: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(double size) => Container(
    width: size,
    height: size,
    decoration: const BoxDecoration(
      color: Colors.black,
      shape: BoxShape.circle,
    ),
  );

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
          'Enter Your PIN',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 64),
          Text(
            'Enter your PIN to confirm payment',
            style: GoogleFonts.outfit(fontSize: 18, color: Colors.black87),
          ),
          const SizedBox(height: 48),
          _buildPinFields(),
          const SizedBox(height: 48),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ElevatedButton(
              onPressed: _pin.length == 4 ? _confirmPayment : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
                minimumSize: const Size(double.infinity, 64),
                elevation: 8,
                shadowColor: Colors.black.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              child: Text(
                'Continue',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Spacer(),
          _buildNumPad(),
        ],
      ),
    );
  }

  Widget _buildPinFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        bool isTyped = index < _pin.length;
        bool isCurrent = index == _pin.length - 1;
        String char = isTyped ? _pin[index] : "";

        return Container(
          width: 72,
          height: 64,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: isTyped && !isCurrent ? Colors.white : Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isCurrent
                  ? Colors.black
                  : Colors.black.withValues(alpha: 0.05),
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: isTyped && !isCurrent
              ? Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                )
              : Text(
                  char,
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        );
      }),
    );
  }

  Widget _buildNumPad() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [_numBtn("1"), _numBtn("2"), _numBtn("3")],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [_numBtn("4"), _numBtn("5"), _numBtn("6")],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [_numBtn("7"), _numBtn("8"), _numBtn("9")],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [_numBtn("*"), _numBtn("0"), _buildBackspace()],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _numBtn(String text) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _onKeyPress(text),
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 48,
          alignment: Alignment.center,
          child: Text(
            text,
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspace() {
    return Expanded(
      child: GestureDetector(
        onTap: _onBackspace,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 48,
          alignment: Alignment.center,
          child: const Icon(Icons.backspace_outlined, size: 24),
        ),
      ),
    );
  }
}
