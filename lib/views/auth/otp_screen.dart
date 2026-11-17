import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/routes/app_router.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/custom_button.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const int _length = 6;
  final List<TextEditingController> _controllers =
      List.generate(_length, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(_length, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  String get _otp => _controllers.map((c) => c.text).join();

  Future<void> _verify() async {
    if (_otp.length != _length) {
      _snack('Enter the 6 digit OTP');
      return;
    }
    final auth = context.read<AuthViewModel>();
    final ok = await auth.verifyOtp(_otp);
    if (!mounted) return;
    if (ok) {
      _snack('OTP verified. Please sign in.');
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (r) => false);
    } else {
      _snack(auth.error ?? 'Invalid OTP');
    }
  }

  Future<void> _resend() async {
    final auth = context.read<AuthViewModel>();
    final ok = await auth.resendOtp();
    if (!mounted) return;
    _snack(ok ? 'OTP sent again' : (auth.error ?? 'Could not resend OTP'));
  }

  OutlineInputBorder _border(Color color, {double width = 1}) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: width),
      );

  Widget _otpBox(int i) {
    return SizedBox(
      height: 52,
      child: TextField(
        controller: _controllers[i],
        focusNode: _nodes[i],
        autofocus: i == 0,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          enabledBorder: _border(AppColors.border),
          focusedBorder: _border(AppColors.primary, width: 2),
        ),
        onChanged: (v) {
          if (v.isNotEmpty && i < _length - 1) {
            _nodes[i + 1].requestFocus();
          } else if (v.isEmpty && i > 0) {
            _nodes[i - 1].requestFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    const AppLogo(),
                    const SizedBox(height: 24),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.vertical(top: Radius.circular(32)),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 12),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Whatsapp OTP\nVerification',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                height: 1.15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Please ensure that the email id mentioned is valid '
                              'as we have sent an OTP to your email.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.4,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 28),

                            // Six equal boxes that shrink or grow with the screen width.
                            Row(
                              children: [
                                for (int i = 0; i < _length; i++) ...[
                                  Expanded(child: _otpBox(i)),
                                  if (i < _length - 1) const SizedBox(width: 10),
                                ],
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              auth.pendingEmail ?? '',
                              style: const TextStyle(fontSize: 13),
                            ),

                            // Pushes the resend text and Verify button to the bottom.
                            const Spacer(),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Didn't receive OTP code? ",
                                    style: TextStyle(fontSize: 13)),
                                GestureDetector(
                                  onTap: auth.isLoading ? null : _resend,
                                  child: const Text('Resend OTP',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            CustomButton(
                                text: 'Verify', isLoading: auth.isLoading, onPressed: _verify),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}