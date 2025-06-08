import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Réinitialiser mot de passe")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text("Entrez votre email", style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 10),
            Text("Un lien de réinitialisation vous sera envoyé", style: TextStyle(color: Colors.grey[600])),

            const SizedBox(height: 30),
            TextField(controller: emailCtrl, decoration: const InputDecoration(hintText: "Adresse email")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Envoyer le lien"),
            ),
          ],
        ),
      ),
    );
  }
}
