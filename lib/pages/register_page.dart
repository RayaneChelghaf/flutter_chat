import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chat/components/my_button.dart';
import 'package:flutter_chat/components/my_text_field.dart';
import 'package:flutter_chat/services/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign up user
  void signUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
        content: Text("Passwords do not match"),
      ),
      );
      return;
    }

    // get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

 try {
   await authService.signUpWithEmailandPassword(
     emailController.text,
     passwordController.text,
   );
 } catch (e) {
   ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
       content: Text(e.toString()),
     ),
   );
 }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // logo
                Icon(
                  Icons.message,
                  size: 80,
                  color: Colors.grey[800],
                ),

                const SizedBox(height: 50),

                // create account message
                const Text(
                  "Création de compte",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // email text field
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password text field
                MyTextField(
                  controller: passwordController,
                  hintText: 'Mot de passe',
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                // confirm password text field
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirmer le mot de passe',
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                // sign up button
                MyButton(onTap: signUp, text: "Inscription"),

                const SizedBox(height: 50),

                // not a member ? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Déjà un compte ?'),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Connexion',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
