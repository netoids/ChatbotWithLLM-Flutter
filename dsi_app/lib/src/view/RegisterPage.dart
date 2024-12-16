import 'package:dsi_app/src/services/autentication_service.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
//import 'package:dsi_app/src/alth/components/custom_text_field.dart';

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
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height * 0.55,
          width: size.width,
          child: Stack(
            children: [
              Column(
                children: [
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Cadastro',
                        style: TextStyle(
                            color: Color.fromARGB(255, 50, 201, 199),
                            fontSize: 35),
                      ),
                    ),
                  ),
                  // Formulario
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 40,
                    ),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(45))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'Digite seu nome',
                            labelText: 'Nome',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Digite seu email',
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: 'Digite sua senha',
                            labelText: 'Senha',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          obscureText: true,
                        ),
                        //BOTÃO CADASTRAR USUÁRIO
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 50, 201, 199),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    )),
                                onPressed: () {
                                  _autenticationService.registerUser(
                                    nome: _nameController.text,
                                    email: _emailController.text,
                                    senha: _passwordController.text);
                                  Navigator.pushNamed(context, "/LoginPage");
                                },
                                child: const Text(
                                  'Criar Conta',
                                  style: TextStyle(fontSize: 18),
                                )),
                          ),
                        )
                      ],
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
        ),
      ),
    );
  }
}