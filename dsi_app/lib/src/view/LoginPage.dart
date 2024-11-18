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
  final TextFieldController textFieldController = TextFieldController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
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
                      const CustomTextField(icon: Icons.email, label: 'Email'),
                      // SENHA
                      const CustomTextField(
                        icon: Icons.lock,
                        label: 'Senha',
                        isSecret: true,
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
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28))),
                              onPressed: () {
                                textFieldController.getEmailFromTextField();
                                textFieldController.getPasswordFromTextField();
                                Navigator.popAndPushNamed(
                                    context, "/EnterPage");
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
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              'ou',
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.green),
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
