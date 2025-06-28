import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inside_casa_app/theme/AppTheme.dart';
import 'features/partner/authentication/screens/partner_login_screen.dart';
import 'features/partner/authentication/screens/partner_registration_screen.dart';
import 'features/partner/screens/partner_profile_screen.dart';
import 'features/partner/screens/change_password_screen.dart';
import 'features/partner/services/api_service.dart';
import 'features/partner/authentication/screens/partner_pending_approval_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<ApiService>(
          create: (_) => ApiService(),
        ),
      ],
      child: const InsideCasaApp(),
    ),
  );
}

class InsideCasaApp extends StatelessWidget {
  const InsideCasaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InsideCasa Partner App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const PartnerLoginScreen(),
      routes: {
        PartnerLoginScreen.routeName: (ctx) => const PartnerLoginScreen(),
        PartnerRegistrationScreen.routeName: (ctx) => const PartnerRegistrationScreen(),
        PartnerProfileScreen.routeName: (ctx) => const PartnerProfileScreen(),
        ChangePasswordScreen.routeName: (ctx) => const ChangePasswordScreen(token: ''),
        PartnerPendingApprovalScreen.routeName: (ctx) => const PartnerPendingApprovalScreen(),
      },
    );
  }
}