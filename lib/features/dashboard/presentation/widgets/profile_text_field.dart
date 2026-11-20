import 'package:flutter/material.dart';

class ProfileTextField extends StatelessWidget {
  final String label;
  final String text;
  final IconData prefixIcon;

  const ProfileTextField({
    super.key,
    required this.label,
    required this.text,
    required this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: text,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        hintText: label,
        prefixIcon: Icon(prefixIcon),
        enabled: false,
        enabledBorder: OutlineInputBorder(),
        prefixIconColor: Colors.black,
      ),
    );
  }
}
