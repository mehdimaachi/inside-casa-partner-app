// In: lib/features/partner/screens/partner_login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'partner_dashboard_screen.dart'; // The main dashboard screen
import '../services/api_service.dart';
import '../models/user.dart';
// We ONLY need to import the central theme file now
import 'package:inside_casa_app/theme/AppTheme.dart';

class PartnerLoginScreen extends StatefulWidget {
  const PartnerLoginScreen({super.key});

  @override
  State<PartnerLoginScreen> createState() => _PartnerLoginScreenState();
}

class _PartnerLoginScreenState extends State<PartnerLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _apiService = ApiService();
  final _storage = const FlutterSecureStorage();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _performLogin() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // --- FAKE LOGIN LOGIC ---
    try {
      await Future.delayed(const Duration(seconds: 1));
      final fakeUser = PartnerUser(
        id: 1, fullname: "Test Partner", email: "partner@test.com", phone: "123456789", role: 'partner', createdAt: DateTime.now(), updatedAt: DateTime.now(),
      );
      const fakeToken = 'fake-jwt-token-for-testing';
      await _storage.write(key: 'auth_token', value: fakeToken);
      await _storage.write(key: 'partner_id', value: fakeUser.id.toString());
      await _storage.write(key: 'partner_name', value: fakeUser.fullname);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => PartnerDashboardScreen(partner: fakeUser),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst("Exception: ", "");
      });
    } finally {
      if(mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The scaffold's background color is now controlled by the global theme in main.dart
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Logo
                  Image.asset(
                    'images/LogoInsideCasa.png',
                    height: 60,
                  ),
                  const SizedBox(height: 32),

                  // 2. Welcome Text
                  const Text(
                    'Bienvenue',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  // --- FIXED: Using AppTheme.lightText instead of AppColors ---
                  Text(
                    'Connecte-toi pour gérer ton espace partenaire !',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: AppTheme.lightText), // Corrected
                  ),
                  const SizedBox(height: 40),

                  // 3. Email Field - The style is applied automatically by the theme in main.dart
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration( // 'const' is fine here
                      hintText: 'Adresse email',
                      // The prefixIconColor is now set globally in AppTheme.dart
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => (value == null || !value.contains('@')) ? 'Veuillez entrer un email valide' : null,
                  ),
                  const SizedBox(height: 16),

                  // 4. Password Field - The style is applied automatically by the theme
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration( // 'const' is fine here
                      hintText: 'Mot de passe',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                    validator: (value) => (value == null || value.length < 6) ? 'Le mot de passe doit contenir au moins 6 caractères' : null,
                  ),
                  const SizedBox(height: 24),

                  // Error message
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ),

                  // 5. Login Button - The style is applied automatically by the theme
                  ElevatedButton(
                    onPressed: _isLoading ? null : _performLogin,
                    child: _isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Connexion'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}