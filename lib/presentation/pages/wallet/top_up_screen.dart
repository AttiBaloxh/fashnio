import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../state_managements/providers/wallet_provider.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({super.key});

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen>
    with SingleTickerProviderStateMixin {
  final List<double> _quickAmounts = [
    10,
    20,
    50,
    100,
    200,
    250,
    500,
    750,
    1000,
  ];
  String _amountText = '';

  double get _amount => double.tryParse(_amountText) ?? 0;
  bool get _isValid => _amount > 0;

  void _onKeypadTap(String value) {
    setState(() {
      if (value == '<') {
        if (_amountText.isNotEmpty) {
          _amountText = _amountText.substring(0, _amountText.length - 1);
        }
      } else if (value == '*') {
        // Disabled
      } else {
        if (_amountText.length < 6) {
          if (_amountText == '0' && value != '0') {
            _amountText = value;
          } else if (_amountText == '0' && value == '0') {
            // Keep it as 0
          } else {
            _amountText += value;
          }
        }
      }
    });
  }

  void _onQuickAmountSelected(double amount) {
    setState(() {
      _amountText = amount.toInt().toString();
    });
  }

  Future<void> _onTopUp() async {
    if (!_isValid) return;
    Navigator.pushNamed(context, '/top-up-payment', arguments: _amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
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
      body: Consumer<WalletProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 14),
                      Text(
                        'Enter the amount of top up',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildAmountBox(),
                      const SizedBox(height: 22),
                      _buildQuickAmounts(),
                      _buildContinueButton(provider),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              _buildKeypad(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAmountBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black87, width: 1.5),
      ),
      child: Text(
        _amountText.isEmpty
            ? '\$0'
            : '\$${_amountText.replaceAllMapped(RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (match) => "${match[1]},")}',
        textAlign: TextAlign.center,
        style: GoogleFonts.outfit(
          fontSize: 54,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF333A47),
          letterSpacing: -1,
        ),
      ),
    );
  }

  Widget _buildQuickAmounts() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _quickAmounts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        childAspectRatio: 2.3,
      ),
      itemBuilder: (context, index) {
        final amount = _quickAmounts[index];
        final formattedAmount =
            '\$${amount.toInt().toString().replaceAllMapped(RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (match) => "${match[1]},")}';
        final isSelected = _amountText == amount.toInt().toString();

        return GestureDetector(
          onTap: () => _onQuickAmountSelected(amount),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.black, width: 1.2),
            ),
            alignment: Alignment.center,
            child: Text(
              formattedAmount,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContinueButton(WalletProvider provider) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: (_isValid && !provider.isLoading) ? _onTopUp : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF131313),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[400],
          disabledForegroundColor: Colors.white70,
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
    );
  }

  Widget _buildKeypad() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 4, 10),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          _buildKeypadRow(['1', '2', '3']),
          _buildKeypadRow(['4', '5', '6']),
          _buildKeypadRow(['7', '8', '9']),
          _buildKeypadRow(['*', '0', '<']),
        ],
      ),
    );
  }

  Widget _buildKeypadRow(List<String> keys) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: keys.map((key) {
          if (key == '<') {
            return _buildKeypadButton(
              key,
              icon: const Icon(
                Icons.backspace_outlined,
                color: Color(0xFF4A5568),
                size: 28,
              ),
            );
          }
          return _buildKeypadButton(key);
        }).toList(),
      ),
    );
  }

  Widget _buildKeypadButton(String key, {Widget? icon}) {
    return GestureDetector(
      onTap: () => _onKeypadTap(key),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80,
        height: 60,
        child: Center(
          child:
              icon ??
              Text(
                key,
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
        ),
      ),
    );
  }
}
