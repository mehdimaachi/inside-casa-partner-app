import 'package:flutter/material.dart';
import 'package:inside_casa_app/user-interface/auth/register/RegisterScreen.dart';
import 'package:inside_casa_app/user-interface/auth/resetPassword/ResetPasswordScreen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Text("Bienvenue 👋", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 10),
              Text("Connecte-toi pour explorer Casablanca !", style: TextStyle(color: Colors.grey[600])),

              const SizedBox(height: 30),
              TextField(controller: emailCtrl, decoration: const InputDecoration(hintText: "Adresse email")),
              const SizedBox(height: 16),
              TextField(controller: passwordCtrl, obscureText: true, decoration: const InputDecoration(hintText: "Mot de passe")),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ResetPasswordScreen())),
                  child: const Text("Mot de passe oublié ?"),
                ),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Connexion"),
              ),

              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Pas encore de compte ?"),
                  TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                    child: const Text("Créer un compte"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
