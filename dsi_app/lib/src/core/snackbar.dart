import 'package:flutter/material.dart';

void showSnackBar(
  {required BuildContext context, 
  required String message, 
  bool isErro = true}) {
  SnackBar snackBar = SnackBar(
    content: Text(message),
    backgroundColor: isErro ? Colors.red : Colors.green,
  );
  
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}