import 'package:flutter/material.dart';
import 'package:dsi_app/src/alth/components/custom_text_field.dart';
// Supondo que você tenha esse componente para os campos de texto

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});
  static const routeName = '/ForgotPassword';

  @override
  State<Forgotpassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<Forgotpassword> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Função que simula o envio de recuperação de senha
  Future<void> _sendPasswordResetEmail() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Simulação de envio
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solicitação de recuperação enviada!')),
      );
      // Aqui você pode chamar uma função real para fazer a solicitação de recuperação, como uma API
      // Exemplo:
      // await authService.sendPasswordResetEmail(_emailController.text);
    }
  }

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
                          fontSize: 35,
                        ),
                      ),
                    ),
                  ),

                  // Formulário de recuperação
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 40,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(45)),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Informe seu email para que possamos enviar uma solicitação de recuperação',
                          ),
                          const SizedBox(height: 16),

                          // Campo de email
                          CustomTextField(
                            controller: _emailController,
                            icon: Icons.email,
                            label: 'Email',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira um email';
                              }
                              // Validação simples de email
                              final emailRegExp = RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                              if (!emailRegExp.hasMatch(value)) {
                                return 'Por favor, insira um email válido';
                              }
                              return null;
                            },
                          ),

                          // Botão de enviar
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
                                  ),
                                ),
                                onPressed: _sendPasswordResetEmail,
                                child: const Text(
                                  'Enviar',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Botão voltar
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
