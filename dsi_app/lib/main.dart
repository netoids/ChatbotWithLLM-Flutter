import 'package:flutter/material.dart';
import 'package:dsi_app/src/shared/AppColors.dart';
import 'package:dsi_app/src/view/LoginPage.dart';
import 'package:dsi_app/src/view/RegisterPage.dart';
import 'package:dsi_app/src/view/EnterPage.dart';
import 'package:dsi_app/src/view/ForgotPassword.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MaterialColor appPrimarySwatch =
        MaterialColor(AppColors.green.value, <int, Color>{
      50: AppColors.green.withOpacity(0.1),
      100: AppColors.green.withOpacity(0.2),
      200: AppColors.green.withOpacity(0.3),
      300: AppColors.green.withOpacity(0.4),
      400: AppColors.green.withOpacity(0.5),
      500: AppColors.green.withOpacity(0.6),
      600: AppColors.green.withOpacity(0.7),
      700: AppColors.green.withOpacity(0.8),
      800: AppColors.green.withOpacity(0.9),
      900: AppColors.green.withOpacity(1.0),
    });

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'LLM-Prototipe',
        theme: ThemeData(
          primarySwatch: appPrimarySwatch,
          appBarTheme: AppBarTheme(
              elevation: 0, backgroundColor: AppColors.backgroundColor),
        ),
        initialRoute: LoginPage.routeName,
        routes: {
          LoginPage.routeName: (context) => const LoginPage(),
          Registration.routeName: (context) => const Registration(),
          EnterPage.routeName: (context) => const EnterPage(),
          Forgotpassword.routeName: (context) => const Forgotpassword(),
        });
  }
}
