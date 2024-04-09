import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isError;
  final bool isMultiline;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.isError = false,
    this.isMultiline = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: isMultiline ? null : 1,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 26.0,
        ),
        labelStyle: const TextStyle(
          color: Colors.black,
          fontSize: 17,
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: !isError
              ? const BorderSide(color: Colors.black, width: 1.0)
              : const BorderSide(color: Colors.red, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: !isError
              ? const BorderSide(color: Colors.black, width: 1.0)
              : const BorderSide(color: Colors.red, width: 2.0),
        ),
      ),
    );
  }
}
