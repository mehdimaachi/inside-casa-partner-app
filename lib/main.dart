import 'package:flutter/material.dart';
import 'package:inside_casa_app/theme/AppTheme.dart';

// Import all necessary screens and services
import 'features/partner/services/api_service.dart';
import 'features/partner/authentication/screens/partner_login_screen.dart';
import 'features/partner/authentication/screens/partner_registration_screen.dart';
import 'features/partner/screens/partner_profile_screen.dart';
import 'features/partner/screens/change_password_screen.dart';

void main() {
  // We are not using Provider, so we run the app directly.
  runApp(const InsideCasaApp());
}

class InsideCasaApp extends StatelessWidget {
  const InsideCasaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InsideCasa Partner App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      // --- REVERTED TO NORMAL APP FLOW ---
      // The Login Screen is now the starting point.
      home: const PartnerLoginScreen(),
      // ------------------------------------

      // All routes are defined for navigation throughout the app.
      routes: {
        PartnerLoginScreen.routeName: (ctx) => const PartnerLoginScreen(),
        PartnerRegistrationScreen.routeName: (ctx) => const PartnerRegistrationScreen(),
        PartnerProfileScreen.routeName: (ctx) => const PartnerProfileScreen(),
        // Note: ChangePasswordScreen is navigated to via MaterialPageRoute, so a route name here is optional but good practice.
        ChangePasswordScreen.routeName: (ctx) => const ChangePasswordScreen(token: ''), // Token will be passed in navigation
      },
    );
  }
}