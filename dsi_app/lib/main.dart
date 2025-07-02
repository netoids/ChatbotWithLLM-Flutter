import 'package:dsi_app/src/view/chatbot_history.dart';
import 'package:flutter/material.dart';
import 'package:dsi_app/src/shared/app_colors.dart';
import 'package:dsi_app/src/view/login_page.dart';
import 'package:dsi_app/src/view/register_page.dart';
import 'package:dsi_app/src/view/user_chatbot_page.dart';
import 'package:dsi_app/src/view/forgot_password.dart';
import 'package:dsi_app/src/view/user_config.dart';
import 'package:dsi_app/src/view/user_selection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dsi_app/src/view/chat_detail.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LLM-Prototipe',
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color.fromARGB(255, 50, 201, 199),
          selectionColor: Color.fromARGB(255, 50, 201, 199),
          selectionHandleColor: Color.fromARGB(255, 50, 201, 199),
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: AppColors.backgroundColor,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00A3A0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 50, 201, 199), // Cor ao focar
              width: 2.0,
            ),
          ),
          floatingLabelStyle: TextStyle(
            color: Color.fromARGB(255, 50, 201, 199), // Cor do texto flutuante
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      supportedLocales: const [
        Locale('pt', 'BR'), // Português do Brasil
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: LoginPage.routeName,
      routes: {
        LoginPage.routeName: (context) => const LoginPage(),
        Registration.routeName: (context) => Registration(),
        Forgotpassword.routeName: (context) => const Forgotpassword(),
        ConfigPage.routeName: (context) => const ConfigPage(),
        ChatHistory.routeName: (context) => const ChatHistory(),
        UserSelectionScreen.routeName: (context) => const UserSelectionScreen(),
        ChatDetail.routeName: (context) => const ChatDetail(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == EnterPage.routeName) {
          final args = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => EnterPage(userName: args),
          );
        }
        return null; // Handle unknown routes
      },
    );
  }
}
