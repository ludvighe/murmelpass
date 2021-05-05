import 'package:flutter/material.dart';
import 'package:password_manager_r1/providers/password_data_provider.dart';

class SearchField extends StatelessWidget {
  SearchField({this.controller, this.onChanged, this.onClear});
  TextEditingController controller;
  Function onChanged;
  Function onClear;
  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      controller: controller,
      decoration: InputDecoration(
          hintText: 'Search',
          suffixIcon: IconButton(
            onPressed: onClear,
            icon: Icon(Icons.clear),
          )),
      onChanged: onChanged,
    );
  }
}
