import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/routes/app_router.dart';
import '../../core/utils/validators.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthViewModel>();
    final ok = await auth.login(email: _email.text.trim(), password: _password.text);
    if (!mounted) return;
    if (ok) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.dashboard, (r) => false);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(auth.error ?? 'Login failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<AuthViewModel>().isLoading;

    return Scaffold(
      body: SafeArea(
        // LayoutBuilder + minHeight makes the column fill the screen, so the
        // Spacer below can push the button to the bottom. The scroll view keeps
        // it usable when the keyboard opens or on small screens.
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
                              const Text('Welcome',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary)),
                              const SizedBox(height: 4),
                              const Text('Please sign-in to continue',
                                  style: TextStyle(
                                      fontSize: 13, color: AppColors.textSecondary)),
                              const SizedBox(height: 28),
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
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Coming soon')),
                                  ),
                                  child: const Text('Forgot Password?',
                                      style: TextStyle(
                                          fontSize: 13, color: AppColors.textPrimary)),
                                ),
                              ),

                              // Takes all the remaining height, which creates the
                              // gap between the form and the bottom section.
                              const Spacer(),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Don't have an account? ",
                                      style: TextStyle(fontSize: 13)),
                                  GestureDetector(
                                    onTap: () => Navigator.pushNamedAndRemoveUntil(
                                        context, AppRoutes.signup, (r) => false),
                                    child: const Text('Sign Up',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              CustomButton(
                                  text: 'Sign In', isLoading: loading, onPressed: _submit),
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