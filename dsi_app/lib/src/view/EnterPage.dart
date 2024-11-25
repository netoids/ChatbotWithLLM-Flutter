import 'package:flutter/material.dart';

class EnterPage extends StatefulWidget {
  const EnterPage({super.key});
  static const routeName = '/EnterPage';

  @override
  State<EnterPage> createState() => _EnterPageState();
}

class _EnterPageState extends State<EnterPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tela Principal'),
        ),
        body: Container(
          color: Color.fromARGB(255, 50, 201, 199),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Você Logou!',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/Login");
                    },
                    child: const Text('Voltar'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/Config");
                    },
                    child: const Text('Configurar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
