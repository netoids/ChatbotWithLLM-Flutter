import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final IconData icon;
  final String label;
  final double iconSize;
  final bool isObscure;
  final String? Function(String?)? validator;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.icon,
    required this.label,
    this.isObscure = false,
    this.iconSize = 20,
    this.validator,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: isObscure,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            size: iconSize,
          ),
          labelText: label,
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
