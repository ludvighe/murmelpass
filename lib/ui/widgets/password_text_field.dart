import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  PasswordTextField(
      {this.controller, this.decoration, this.hint, this.enabled = true});

  final TextEditingController controller;
  final InputDecoration decoration;

  final String hint;
  final bool enabled;

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller ?? TextEditingController(),
      obscureText: _obscurePassword,
      decoration: widget.decoration ??
          InputDecoration(
            hintText: widget.hint ?? "Enter password",
            suffixIcon: InkWell(
              borderRadius: BorderRadius.circular(24.0),
              onTap: () {
                setState(
                  () {
                    _obscurePassword = !_obscurePassword;
                  },
                );
              },
              child: Icon(
                Icons.visibility,
                color: (_obscurePassword)
                    ? Colors.grey
                    : Theme.of(context).primaryColor,
              ),
            ),
          ),
      enabled: widget.enabled,
    );
  }
}
