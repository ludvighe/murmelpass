import 'package:flutter/material.dart';
import 'package:password_manager_r1/ui/pages/login_page/login_container.dart';
import 'package:password_manager_r1/ui/widgets/responsive/responsive_widget.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: ResponsiveWidget(
        mobile: LoginContainer(),
        desktop: Center(
          child: SizedBox(
            width: 500,
            height: 800,
            child: LoginContainer(),
          ),
        ),
      ),
    );
  }
}
