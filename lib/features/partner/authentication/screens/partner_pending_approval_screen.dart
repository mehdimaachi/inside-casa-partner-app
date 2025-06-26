import 'package:flutter/material.dart';
import './partner_login_screen.dart'; // To navigate back to login

class PartnerPendingApprovalScreen extends StatelessWidget {
  // We add a routeName here for consistency, though we navigate to it directly.
  static const routeName = '/pending-approval';

  const PartnerPendingApprovalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Submitted'),
        automaticallyImplyLeading: false, // Prevents a back arrow
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.hourglass_top_rounded,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Thank You!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Your registration has been submitted successfully. Our team will review your application and you will be notified via email once it is approved.',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Navigate back to the login screen, clearing all other screens
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    PartnerLoginScreen.routeName,
                        (Route<dynamic> route) => false,
                  );
                },
                child: const Text('BACK TO LOGIN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}