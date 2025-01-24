// ignore_for_file: use_build_context_synchronously

import 'package:dsi_app/src/services/autentication_service.dart';
import 'package:dsi_app/src/shared/app_colors.dart';
import 'package:dsi_app/src/shared/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:dsi_app/src/core/snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const routeName = '/Login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AutenticationService _autenticationService = AutenticationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 245, 250),
      body: Column(
        children: [
          // LOGO
          const Expanded(
            flex: 2,
            child: Center(
              child: Text(
                "Logo",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 50, 201, 199),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(45)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // EMAIL FIELD
                    CustomTextField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.home,
                      hint: 'Digite seu email',
                    ),
                    const SizedBox(height: 16),
                    // PASSWORD FIELD
                    CustomTextField(
                      hint: 'Digite sua senha',
                      label: 'Senha',
                      icon: Icons.lock,
                      controller: _passwordController,
                      isobscure: true,
                    ),

                    const SizedBox(height: 24),
                    // LOGIN BUTTON
                    SizedBox(
                      height: 55,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 50, 201, 199),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        onPressed: () {
                          _autenticationService
                              .loginUser(
                                  email: _emailController.text,
                                  senha: _passwordController.text)
                              .then((String? error) {
                            if (error != null) {
                              showSnackBar(context: context, message: error);
                            } else {
                              Navigator.popAndPushNamed(
                                  context, "/UserSelection");
                            }
                          });
                        },
                        child: const Text(
                          'Entrar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // DIVIDER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade300,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'ou',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade300,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // SIGN UP BUTTON
                    SizedBox(
                      height: 55,
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.popAndPushNamed(context, '/Registration');
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Color.fromARGB(255, 50, 201, 199)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28)),
                        ),
                        child: const Text(
                          "Criar Conta",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 50, 201, 199),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // FORGOT PASSWORD BUTTON
                    TextButton(
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/ForgotPassword');
                      },
                      child: Text(
                        'Esqueceu a senha?',
                        style: TextStyle(color: AppColors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
