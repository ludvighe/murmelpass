import 'package:flutter/material.dart';
import 'package:password_manager_r1/consts/responsive.dart';
import 'package:password_manager_r1/ui/pages/password_edit_page/password_edit_container.dart';

class PasswordEditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: (MediaQuery.of(context).size.width < DESKTOP_MIN_WIDTH)
          ? Theme.of(context).primaryColor
          : Theme.of(context).scaffoldBackgroundColor,
      body: PasswordEditContainer(),
    );
  }
}
