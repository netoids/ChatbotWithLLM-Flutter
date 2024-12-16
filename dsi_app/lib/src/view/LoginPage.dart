import 'package:dsi_app/src/services/autentication_service.dart';
import 'package:dsi_app/src/shared/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:dsi_app/src/alth/components/custom_text_field.dart';
import 'package:dsi_app/src/Controller/TextFieldController.dart';

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
      backgroundColor: const Color.fromARGB(255, 50, 201, 199),
      body: Column(
        children: [
          const Expanded(
            flex: 2,
            child: Text("Logo"),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 52,
                vertical: 40,
              ),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(45))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //Email
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
                      // SENHA
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
                      //Entrar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 50, 201, 199),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28))),
                              onPressed: () {
                                _autenticationService.loginUser(
                                  email: _emailController.text,
                                  senha: _passwordController.text).then((value) => null,);
                                  Navigator.pushNamed(context, '/EnterPage');
                              },
                              child: const Text(
                                'Entrar',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              height: 1,
                              width: 100,
                              color: Colors.grey,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10)),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              'ou',
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 50, 201, 199)),
                            ),
                          ),
                          Container(
                              height: 1,
                              width: 100,
                              color: Colors.grey,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10)),
                        ],
                      ),

                      ///CadastroButton
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60),
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.popAndPushNamed(
                                  context, '/Registration');
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(20),
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.grey),
                            ),
                            child: Text(
                              "Criar Conta",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/ForgotPassword');
                          },
                          child: Text(
                            'Esqueceu a senha?',
                            style: TextStyle(color: AppColors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}