import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: 
           Image.asset(
                        "assets/images/Logo.png",
                        fit: BoxFit.cover,
                      ),
        
      
    );
  }
}
