import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import '../../state_managements/providers/wallet_provider.dart';

class TopUpPinScreen extends StatefulWidget {
  final double amount;
  const TopUpPinScreen({super.key, required this.amount});

  @override
  State<TopUpPinScreen> createState() => _TopUpPinScreenState();
}

class _TopUpPinScreenState extends State<TopUpPinScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _pinController = TextEditingController();
  late AnimationController _successAnimController;

  @override
  void initState() {
    super.initState();
    _successAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    _successAnimController.dispose();
    super.dispose();
  }

  void _onKeypadTap(String value) {
    if (value == '<') {
      if (_pinController.text.isNotEmpty) {
        _pinController.text = _pinController.text.substring(
          0,
          _pinController.text.length - 1,
        );
      }
    } else if (value == '*') {
      // Ignored
    } else {
      if (_pinController.text.length < 4) {
        _pinController.text += value;
      }
    }
    setState(() {});
  }

  Future<void> _onContinue() async {
    final walletProvider = context.read<WalletProvider>();
    await walletProvider.topUp(widget.amount);
    if (!mounted) return;
    _showSuccessSheet();
  }

  void _showSuccessSheet() {
    FocusScope.of(
      context,
    ).unfocus(); // Dismiss any keyboard if native is magically shown
    _successAnimController.forward(from: 0);
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (_) => _SuccessSheet(
        amount: widget.amount,
        onDone: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 72,
      height: 64,
      textStyle: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12, width: 1),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: Colors.black, width: 1.5),
        color: Colors.white,
      ),
    );

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
          'Enter Your PIN',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
      ),
      body: Consumer<WalletProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 48),
                      Text(
                        'Enter your PIN to confirm top up',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 48),
                      Pinput(
                        length: 4,
                        controller: _pinController,
                        obscureText: true,
                        obscuringWidget: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                        useNativeKeyboard: false,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              _buildContinueButton(provider),
              const SizedBox(height: 16),
              _buildKeypad(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContinueButton(WalletProvider provider) {
    bool isComplete = _pinController.text.length == 4;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: ElevatedButton(
        onPressed: (isComplete && !provider.isLoading) ? _onContinue : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF131313),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[300],
          disabledForegroundColor: Colors.white70,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: isComplete ? 8 : 0,
          shadowColor: Colors.black.withValues(alpha: 0.2),
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

// ─────────────────────────────────────────────
// Success Bottom Sheet
// ─────────────────────────────────────────────

class _SuccessSheet extends StatelessWidget {
  final double amount;
  final VoidCallback onDone;

  const _SuccessSheet({required this.amount, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 48),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 4,
            margin: const EdgeInsets.only(bottom: 32),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          _buildSuccessIcon(),
          const SizedBox(height: 28),
          Text(
            'Top Up Successful!',
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '\$${amount.toStringAsFixed(amount == amount.truncate() ? 0 : 2)} has been added\nto your wallet.',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 36),
          ElevatedButton(
            onPressed: onDone,
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
              'Back to Wallet',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.05),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 90,
          height: 90,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 44),
        ),
        ..._dots(),
      ],
    );
  }

  List<Widget> _dots() => [
    Positioned(top: 8, left: 24, child: _dot(7)),
    Positioned(top: 4, right: 30, child: _dot(5)),
    Positioned(bottom: 12, left: 18, child: _dot(5)),
    Positioned(bottom: 8, right: 24, child: _dot(7)),
    Positioned(left: 0, top: 50, child: _dot(5)),
    Positioned(right: 0, top: 50, child: _dot(5)),
  ];

  Widget _dot(double size) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: Colors.black.withValues(alpha: 0.15),
      shape: BoxShape.circle,
    ),
  );
}
