// ignore_for_file: use_build_context_synchronously

import 'package:dsi_app/src/shared/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:dsi_app/src/services/autentication_service.dart';
import 'package:dsi_app/src/core/snackbar.dart';

class Registration extends StatelessWidget {
  static const routeName = '/Registration';
  Registration({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AutenticationService _autenticationService = AutenticationService();

  final cpfFormater = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {'#': RegExp(r'[0-9]')});

  final telefoneFormater = MaskTextInputFormatter(
      mask: '(##)# ####-####', filter: {'#': RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              // TÍTULO DA PÁGINA
              const Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(left: 32),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Cadastro',
                      style: TextStyle(
                        color: Color.fromARGB(255, 50, 201, 199),
                        fontSize: 35,
                      ),
                    ),
                  ),
                ),
              ),

              // FORMULÁRIO
              Expanded(
                flex: 4,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(45)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 100),

                      //Campo Nome

                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: CustomTextField(
                          hint: 'Digite seu nome',
                          label: 'Nome',
                          icon: Icons.person,
                          controller: _nameController,
                        ),
                      ),

                      //Campo Email

                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: CustomTextField(
                          hint: 'Digite seu email',
                          label: 'Email',
                          icon: Icons.email,
                          controller: _emailController,
                        ),
                      ),

                      //Campo Senha

                      CustomTextField(
                        hint: 'Digite sua senha',
                        label: 'Senha',
                        icon: Icons.lock,
                        controller: _passwordController,
                        isobscure: true,
                      ),
                    ],
                  ),
                ),
              ),

              // BOTÃO "CRIAR CONTA"
              Padding(
                padding: const EdgeInsets.only(bottom: 20), // Eleva o botão
                child: SizedBox(
                  width: size.width * 1.0,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 50, 201, 199),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    onPressed: () {
                      _autenticationService
                          .registerUser(
                        nome: _nameController.text,
                        email: _emailController.text,
                        senha: _passwordController.text,
                      )
                          .then((String? error) {
                        if (error != null) {
                          showSnackBar(context: context, message: error);
                        } else {
                          Navigator.pushNamed(context, "/Login");
                        }
                      });
                    },
                    child: const Text(
                      'Criar Conta',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // BOTÃO VOLTAR
          Positioned(
            left: 10,
            top: 10,
            child: SafeArea(
              child: IconButton(
                color: const Color.fromARGB(255, 50, 201, 199),
                onPressed: () {
                  Navigator.pushNamed(context, "/Login");
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
