import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:dsi_app/src/alth/components/custom_text_field.dart';

class Registration extends StatelessWidget {
  static const routeName = '/Registration';
  Registration({super.key});

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
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              Column(
                children: [
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Cadastro',
                        style: TextStyle(color: Colors.green, fontSize: 35),
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
                        // NOME
                        const CustomTextField(
                          icon: Icons.person,
                          label: 'Nome',
                        ),

                        // SOBRENOME
                        const CustomTextField(
                          icon: Icons.person,
                          label: 'Sobrenome',
                        ),

                        //CPF
                        CustomTextField(
                          icon: Icons.file_copy,
                          label: 'CPF',
                          inputFormaters: [cpfFormater],
                        ),

                        // EMAIL
                        const CustomTextField(
                          icon: Icons.email,
                          label: 'Email',
                        ),

                        // CELULAR
                        CustomTextField(
                          icon: Icons.phone,
                          label: 'Número Para Contato',
                          inputFormaters: [telefoneFormater],
                        ),

                        // SENHA
                        const CustomTextField(
                          icon: Icons.lock,
                          label: 'Senha',
                          isSecret: true,
                        ),

                        // SENHA
                        const CustomTextField(
                          icon: Icons.lock,
                          label: 'Confirmar Senha',
                          isSecret: true,
                        ),

                        //BOTÃO CADASTRAR USUÁRIO
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    )),
                                onPressed: () {},
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
                    color: Colors.green,
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
