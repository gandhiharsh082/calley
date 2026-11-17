import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/routes/app_router.dart';
import '../../widgets/custom_button.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  static const List<List<String>> _languages = [
    ['English', 'Hi'],
    ['Hindi', 'हिन्दी'],
    ['Bengali', 'বাংলা'],
    ['Kannada', 'ಕನ್ನಡ'],
    ['Punjabi', 'ਪੰਜਾਬੀ'],
    ['Tamil', 'தமிழ்'],
    ['Telugu', 'తెలుగు'],
    ['French', 'Bonjour'],
    ['Spanish', 'Hola'],
  ];

  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                'Choose Your Language',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _languages.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.border),
                    itemBuilder: (context, i) {
                      final selected = i == _selected;
                      return InkWell(
                        onTap: () => setState(() => _selected = i),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_languages[i][0],
                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                    Text(_languages[i][1],
                                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                  ],
                                ),
                              ),
                              Icon(
                                selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                                color: selected ? AppColors.primary : AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Select',
                onPressed: () => Navigator.pushNamed(context, AppRoutes.signup),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
