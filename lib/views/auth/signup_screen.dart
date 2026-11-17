import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/routes/app_router.dart';
import '../../core/utils/validators.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _mobile = TextEditingController();
  bool _agreed = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _mobile.dispose();
    super.dispose();
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreed) {
      _snack('Please agree to the Terms and Conditions');
      return;
    }
    final auth = context.read<AuthViewModel>();
    // The API has no mobile field, so only username/email/password are sent.
    final ok = await auth.register(
      username: _name.text.trim(),
      email: _email.text.trim(),
      password: _password.text,
    );
    if (!mounted) return;
    if (ok) {
      Navigator.pushNamed(context, AppRoutes.otp);
    } else {
      _snack(auth.error ?? 'Registration failed');
    }
  }

  /// Read-only country code row from the Figma (flag + +91 + WhatsApp icon).
  Widget _countryCodeRow() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        children: [
          Text('🇮🇳', style: TextStyle(fontSize: 18)),
          SizedBox(width: 8),
          Text('+91', style: TextStyle(fontSize: 14, color: AppColors.textPrimary)),
          Spacer(),
          Icon(Icons.chat_outlined, size: 20, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<AuthViewModel>().isLoading;

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
                        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.vertical(top: Radius.circular(32)),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 12),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const Text('Welcome!',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary)),
                              const SizedBox(height: 4),
                              const Text('Please register to continue',
                                  style: TextStyle(
                                      fontSize: 13, color: AppColors.textSecondary)),
                              const SizedBox(height: 24),
                              CustomTextField(
                                controller: _name,
                                hint: 'Name',
                                icon: Icons.person_outline,
                                validator: (v) => Validators.required(v, 'Name'),
                              ),
                              const SizedBox(height: 12),
                              CustomTextField(
                                controller: _email,
                                hint: 'Email address',
                                icon: Icons.mail_outline,
                                keyboardType: TextInputType.emailAddress,
                                validator: Validators.email,
                              ),
                              const SizedBox(height: 12),
                              CustomTextField(
                                controller: _password,
                                hint: 'Password',
                                isPassword: true,
                                validator: Validators.password,
                              ),
                              const SizedBox(height: 12),
                              _countryCodeRow(),
                              const SizedBox(height: 12),
                              CustomTextField(
                                controller: _mobile,
                                hint: 'Mobile number',
                                icon: Icons.smartphone,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                validator: Validators.mobile,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Checkbox(
                                    value: _agreed,
                                    activeColor: AppColors.primary,
                                    onChanged: (v) => setState(() => _agreed = v ?? false),
                                  ),
                                  Expanded(
                                    child: Text.rich(
                                      TextSpan(
                                        text: 'I agree to the ',
                                        style: const TextStyle(fontSize: 13),
                                        children: [
                                          TextSpan(
                                            text: 'Terms and Conditions',
                                            style: const TextStyle(color: AppColors.primary),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () => _snack('Coming soon'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Pushes "Already have an account?" and the button to the bottom.
                              const Spacer(),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Already have an account? ',
                                      style: TextStyle(fontSize: 13)),
                                  GestureDetector(
                                    onTap: () => Navigator.pushNamed(context, AppRoutes.login),
                                    child: const Text('Sign In',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              CustomButton(
                                  text: 'Sign Up', isLoading: loading, onPressed: _submit),
                            ],
                          ),
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