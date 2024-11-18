import 'package:flutter/material.dart';
import 'package:dsi_app/src/shared/CustomText.dart';
import 'package:dsi_app/src/Controller/TextFieldController.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);
  static const routeName = '/Registration';

  @override
  State<Registration> createState() => RegistrationState();
}

class RegistrationState extends State<Registration> {
  final TextFieldController textFieldController = TextFieldController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Cadastro",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text("Primeiro nome"),
              ),
            ),
            CustomTextField(
              icon: Icons.person,
              label: "Insira o primeiro nome",
              controller: TextEditingController(),
              validator: (value) {
                return null;
              },
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text("Sobrenome"),
              ),
            ),
            CustomTextField(
              icon: Icons.person,
              label: "Insira o sobrenome",
              controller: TextEditingController(),
              validator: (value) {
                return null;
              },
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text("E-mail"),
              ),
            ),
            CustomTextField(
              icon: Icons.email,
              label: "nome@dominio.com",
              controller: TextEditingController(),
              validator: (value) {
                return null;
              },
            ),
            const Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text("Endereço"),
              ),
            ),
            CustomTextField(
              icon: Icons.map,
              label: "Insira o seu endereço",
              controller: TextEditingController(),
              validator: (value) {
                return null;
              },
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text("Senha"),
              ),
            ),
            CustomTextField(
              icon: Icons.lock,
              label: "Insira sua senha",
              isObscure: true,
              controller: TextEditingController(),
              validator: (value) {
                return null;
              },
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text("Confirmar Senha"),
              ),
            ),
            CustomTextField(
              icon: Icons.lock,
              label: "Confirme sua senha",
              isObscure: true,
              controller: TextEditingController(),
              validator: (value) {
                return null;
              },
            ),
            const SizedBox(height: 20), // Add some space between buttons
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () {
                  String email = textFieldController.getEmailFromTextField();
                  String password =
                      textFieldController.getPasswordFromTextField();
                  String username =
                      textFieldController.getGenericNameTextField();
                  String endereco =
                      textFieldController.getGenericNameTextField();
                },
                child: const Text(
                  'Concluir Cadastro',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10), // Add some space between buttons
            TextButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, "/Login");
              },
              child: Text(
                'Já possui uma conta? Faça Login!',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
