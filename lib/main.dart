import 'package:flutter/material.dart';
import 'package:inside_casa_app/theme/appTheme.dart';
import 'package:inside_casa_app/user-interface/auth/login/LoginScreen.dart';
import 'package:inside_casa_app/user-interface/auth/register/RegisterScreen.dart';
import 'features/partner/screens/partner_dashboard_screen.dart';
import 'features/partner/screens/partner_login_screen.dart';
void main() {
  runApp(const InsideCasaApp());
}

class InsideCasaApp extends StatelessWidget {
  const InsideCasaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inside Casa',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const PartnerLoginScreen(),
    );
  }
}
