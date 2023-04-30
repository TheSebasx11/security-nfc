import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:workers_app/src/providers/theme_prov.dart';

// ignore: must_be_immutable
class CustomInputField extends StatelessWidget {
  final String? labelText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  Function()? onTap;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final bool autoFocus;
  final bool obscureText;
  final bool readOnly;
  CustomInputField(
      {this.labelText,
      this.onChanged,
      this.onSubmitted,
      this.errorText,
      this.keyboardType,
      this.textInputAction,
      this.autoFocus = false,
      this.obscureText = false,
      this.readOnly = false,
      this.onTap,
      this.controller,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //final ThemeProvider themeProv = Provider.of<ThemeProvider>(context);
    return TextField(
      autofocus: autoFocus,
      onChanged: onChanged,
      onTap: onTap,
      onSubmitted: onSubmitted,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      controller: controller,
      readOnly: readOnly,
      cursorColor: theme.primaryColor,
      decoration: InputDecoration(
        hoverColor: theme.primaryColor,
        labelText: labelText,
        errorText: errorText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: TextStyle(
            color: theme.brightness.name == "dark"
                ? Colors.white
                : Colors.grey[800]),
        focusColor: theme.primaryColor,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.primaryColor),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
