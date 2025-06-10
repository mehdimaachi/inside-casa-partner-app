import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inside_casa_app/user-interface/auth/register/RegisterScreen.dart';
import 'package:inside_casa_app/user-interface/auth/resetPassword/ResetPasswordScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // Fond blanc
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 50, bottom: 24),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset("images/LogoInsideCasa.png", height: 160),
                  const SizedBox(height: 20),
                  Text(
                    "Bienvenue 👋",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Texte en noir
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Connecte-toi pour explorer Casablanca !",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black54, // Texte gris foncé
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  _buildInput(
                    controller: emailCtrl,
                    hintText: "Adresse email",
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 16),

                  _buildInput(
                    controller: passwordCtrl,
                    hintText: "Mot de passe",
                    obscureText: !showPassword,
                    icon: Icons.lock_outline,
                    isPassword: true,
                    isVisible: showPassword,
                    toggleVisibility: () {
                      setState(() => showPassword = !showPassword);
                    },
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ResetPasswordScreen())),
                      child: Text(
                        "Mot de passe oublié ?",
                        style: GoogleFonts.poppins(
                          color: Colors.blue, // Texte bleu
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4285F4), // Bleu Google
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      "Connexion",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Texte blanc
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Pas encore de compte ?",
                        style: GoogleFonts.poppins(
                          color: Colors.black, // Texte en noir
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const RegisterScreen())),
                        child: Text(
                          "Créer un compte",
                          style: GoogleFonts.poppins(
                            color: Colors.blue, // Texte bleu
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    bool isPassword = false,
    bool isVisible = false,
    VoidCallback? toggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all( // Ajout de la bordure
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isVisible ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: toggleVisibility,
                )
              : null,
          hintText: hintText,
          border: InputBorder.none, // Garde le border none pour le TextField
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        ),
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.black, // Texte en noir
        ),
      ),
    );
  }
}