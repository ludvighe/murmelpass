import 'package:flutter/material.dart';
import 'package:password_manager_r1/providers/async_provider.dart';
import 'package:password_manager_r1/providers/master_password.dart';
import 'package:password_manager_r1/providers/password_data_provider.dart';
import 'package:password_manager_r1/providers/user_provider.dart';
import 'package:password_manager_r1/ui/pages/login_page/login_page.dart';
import 'package:provider/provider.dart';

import 'consts/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MasterPassword>(create: (_) => MasterPassword()),
        ChangeNotifierProvider<PasswordDataProvider>(
            create: (_) => PasswordDataProvider()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider<AsyncProvider>(create: (_) => AsyncProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Password Manager',
        theme: theme,
        home: LoginPage(),
      ),
    );
  }
}
