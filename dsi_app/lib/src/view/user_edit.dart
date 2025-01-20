import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importando o pacote intl para formatação de datas

class UserEdit extends StatefulWidget {
  final String userName;
  final String birthDate; // Adicionando parâmetro para a data de nascimento
  final Function(String, String) onUpdate;

  UserEdit(
      {required this.userName,
      required this.birthDate,
      required this.onUpdate});

  @override
  _UserEditState createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  late TextEditingController _nameController;
  late TextEditingController _birthDateController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
    _birthDateController = TextEditingController(text: widget.birthDate);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  // Função para mostrar o DatePicker
  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            // Alterando para o ThemeData.light()
            colorScheme: ColorScheme.light(
              primary: const Color.fromARGB(
                  255, 0, 163, 160), // Cor do título e ícones
              secondary: const Color.fromARGB(
                  255, 0, 163, 160), // Cor do ícone e botão
            ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            // Mudando a cor de fundo para branco e ajustando o texto para preto
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        _birthDateController.text =
            DateFormat('dd/MM/yyyy').format(selectedDate);
      });
    }
  }

  void _save() {
    widget.onUpdate(_nameController.text, _birthDateController.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Editar Usuário',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 163, 160),
      ),
      body: Stack(
        children: [
          // Centralizando os campos de texto no centro da tela
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Campo de nome do usuário
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nome do Usuário',
                      ),
                    ),
                    const SizedBox(height: 20), // Espaço entre os campos

                    // Campo de data de nascimento
                    GestureDetector(
                      onTap: () => _selectBirthDate(context),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: _birthDateController,
                          decoration: InputDecoration(
                            labelText: 'Data de Nascimento',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Espaço abaixo dos campos
                  ],
                ),
              ),
            ),
          ),

          // Botão "Salvar" fixo na parte inferior
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: size.width,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 50, 201, 199),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  onPressed: _save,
                  child: const Text(
                    'Salvar',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
