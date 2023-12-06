import 'package:flutter/material.dart';
import 'package:flutter_chat/components/my_button.dart';
import 'package:flutter_chat/components/my_text_field.dart';
import 'package:flutter_chat/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign in user
  void signIn() async {
    // get the auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailandPassword(
        emailController.text,
        passwordController.text,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
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
            size: 100,
            color: Colors.grey[800],
          ),

          const SizedBox(height: 50),
          const Text(
            "Bon retour parmi nous !",
             style: TextStyle(
               fontSize: 16,
            ),
          ),

          const SizedBox(height: 25),
          MyTextField(
            controller: emailController,
            hintText: 'Email',
            obscureText: false,
          ),

          const SizedBox(height: 10),

          // password textfield
          MyTextField(
            controller: passwordController,
            hintText: 'Mot de passe',
            obscureText: true,
          ),

          const SizedBox(height: 25),

            // sign in button
            MyButton(onTap: signIn, text: "Inscription"),

            const SizedBox( height: 50),
          // not a member? register now
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Pas encore de compte ?'),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: widget.onTap,
            child: const Text(
              'Inscrivez vous',
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