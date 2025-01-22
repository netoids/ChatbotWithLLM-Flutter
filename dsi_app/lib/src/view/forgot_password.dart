import 'package:dsi_app/src/shared/custom_text_field.dart';
import 'package:flutter/material.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});
  static const routeName = '/ForgotPassword';

  @override
  State<Forgotpassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<Forgotpassword> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              Column(
                children: [
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Recuperar a Senha',
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

                      // EMAIL
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Text(
                              'Informe seu email para que possamos enviar uma solicitação de recuperação'),
                        ),
                        // EMAIL
                        CustomTextField(
                          hint: 'Digite o Email para recuperação',
                          icon: Icons.email,
                          label: 'Email',
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
                                onPressed: () {},
                                child: const Text(
                                  'Enviar',
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
