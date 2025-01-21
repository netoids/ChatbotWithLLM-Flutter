// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final String label;
  final IconData icon;
  final TextEditingController? controller;
  bool isobscure;
  bool visibility;

  CustomTextField({
    super.key,
    required this.hint,
    required this.label,
    required this.icon,
    this.controller,
    this.isobscure = false,
    this.visibility = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  void initState() {
    widget.isobscure ? widget.visibility = !widget.visibility : null;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.visibility,
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hint,
        labelText: widget.label,
        suffixIcon: widget.isobscure
            ? IconButton(
                onPressed: () {
                  setState(() {
                    widget.visibility = !widget.visibility;
                  });
                },
                icon: widget.visibility
                    ? Icon(Icons.visibility)
                    : Icon(Icons.visibility_off),
              )
            : null,
        prefixIcon: Icon(widget.icon, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
