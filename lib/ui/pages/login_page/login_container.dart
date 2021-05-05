import 'package:flutter/material.dart';
import 'package:password_manager_r1/consts/strings.dart';
import 'package:password_manager_r1/models/user.dart';
import 'package:password_manager_r1/providers/async_provider.dart';
import 'package:password_manager_r1/providers/master_password.dart';
import 'package:password_manager_r1/providers/password_data_provider.dart';
import 'package:password_manager_r1/providers/user_provider.dart';
import 'package:password_manager_r1/ui/pages/password_list_page/password_list_page.dart';
import 'package:password_manager_r1/ui/widgets/dialogs/info_dialog.dart';
import 'package:password_manager_r1/ui/widgets/murmel_logo.dart';
import 'package:password_manager_r1/ui/widgets/password_text_field.dart';
import 'package:provider/provider.dart';

class LoginContainer extends StatefulWidget {
  @override
  _LoginContainerState createState() => _LoginContainerState();
}

class _LoginContainerState extends State<LoginContainer> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController keyController = TextEditingController();
    final TextEditingController pwController = TextEditingController();
    bool _keyError = false;
    bool _passwordError = false;

    void _onLogin() async {
      if (keyController.text == null || keyController.text == '') {
        _keyError = true;
      } else {
        _keyError = false;
      }
      if (pwController.text == null || pwController.text == '') {
        _passwordError = true;
      } else {
        _passwordError = false;
      }
      if (_keyError || _passwordError) return;

      // Set loading to true
      Provider.of<AsyncProvider>(context, listen: false).loading = true;

      try {
        //Create user (test user right now)
        User user = await Provider.of<UserProvider>(context, listen: false)
            .login(keyController.text);

        // Store master password
        Provider.of<MasterPassword>(context, listen: false).masterPassword =
            pwController.text;

        // Fetch and store all related passwords
        Provider.of<PasswordDataProvider>(context, listen: false)
            .fetchPasswordData(user);
        // Set loading to false
        Provider.of<AsyncProvider>(context, listen: false).loading = false;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PasswordListPage(),
          ),
        );
      } catch (e) {
        // Set loading to false
        Provider.of<AsyncProvider>(context, listen: false).loading = false;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Login failure'),
            content: Text('Could not log in. Wrong key?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Got it!'))
            ],
          ),
        );
      }
    }

    void _onRegister() {}

    return Container(
      padding: EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 25,
            spreadRadius: 5.0,
            color: Colors.black,
          )
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Murmelpass',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                Expanded(child: MurmelLogo())
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Icon(
                  Icons.vpn_key,
                  color: (_keyError)
                      ? Theme.of(context).errorColor
                      : Theme.of(context).primaryColor,
                ),
              ),
              Expanded(
                flex: 10,
                child: PasswordTextField(
                  hint: 'Key',
                  controller: keyController,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Icon(
                  Icons.lock,
                  color: (_passwordError)
                      ? Theme.of(context).errorColor
                      : Theme.of(context).primaryColor,
                ),
              ),
              Expanded(
                flex: 10,
                child: PasswordTextField(
                  hint: 'Password',
                  controller: pwController,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12.0,
          ),
          ElevatedButton(
            onPressed: _onLogin,
            child: Text('Login'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => Theme.of(context).buttonColor),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '*Murmelpass does not store your password',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                IconButton(
                    onPressed: () => infoDialog(
                        context,
                        'Murmelpass does not store passwords',
                        kNoPasswordStorageDescription),
                    icon: Icon(
                      Icons.info,
                      color: Colors.grey,
                    ))
              ],
            ),
          ),
          Spacer(),
          TextButton(
            onPressed: _onRegister,
            child: Text(
              'I don\'t have a key and would like to register',
            ),
          )
        ],
      ),
    );
  }
}
