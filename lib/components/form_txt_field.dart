import 'package:flutter/material.dart';

class FormTextFieldWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  const FormTextFieldWidget(
      {Key? key, required this.label, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      cursorColor: theme.primaryColor,
      controller: controller,
      decoration: InputDecoration(
        fillColor: theme.primaryColor,
        focusColor: theme.primaryColor,
        labelStyle: theme.textTheme.bodyLarge,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.primaryColor),
          borderRadius: BorderRadius.circular(20),
        ),
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
