import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager_r1/models/user.dart';
import 'package:password_manager_r1/providers/user_provider.dart';
import 'package:password_manager_r1/ui/widgets/password_text_field.dart';
import 'package:provider/provider.dart';

class RegisterContainer extends StatefulWidget {
  @override
  _RegisterContainerState createState() => _RegisterContainerState();
}

class _RegisterContainerState extends State<RegisterContainer> {
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _keyController;

  bool _confirmed = false;
  bool _nameError = false;
  bool _emailError = false;

  User user;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController()..text = '';
    _emailController = TextEditingController()..text = '';
    _keyController = TextEditingController()..text = 'Key not generated';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_nameController.text == '' || _nameController.text == null)
      _nameError = true;
    if (_emailController.text == null ||
        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(_emailController.text)) _emailError = true;
    if (_nameError || _emailError) {
      setState(() {});
      return;
    }
    user = User(name: _nameController.text, email: _emailController.text);
    // TODO: Handle error response
    try {
      await Provider.of<UserProvider>(context, listen: false)
          .register(user)
          .then((value) {
        setState(() {
          user.key = value;
          _keyController.text = user.key;
          _confirmed = true;
        });
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.0),
      // width: 500,
      // height: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Register',
            style: Theme.of(context).textTheme.headline3,
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: _confirmed ? _resultContainer() : _inputContainer(),
          ),
          Spacer(),
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Close'))
        ],
      ),
    );
  }

  Widget _inputContainer() => Column(
        children: [
          _nameInputField(),
          _emailInputField(),
          TextButton(onPressed: _register, child: Text('Generate key')),
        ],
      );

  Widget _resultContainer() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name:\t${user.name}'),
          Text('Email:\t${user.email}'),
          PasswordTextField(
            controller: _keyController,
          ),
          _copyButton(context),
        ],
      );

  Widget _nameInputField() => _inputField(
        controller: _nameController,
        hint: 'Name',
        error: _nameError,
        onChange: (value) {
          setState(() {
            _nameError = false;
          });
        },
      );
  Widget _emailInputField() => _inputField(
        controller: _emailController,
        hint: 'Email',
        error: _emailError,
        onChange: (value) {
          setState(() {
            _emailError = false;
          });
        },
      );

  Widget _inputField({
    TextEditingController controller,
    String hint,
    bool error,
    Function onChange,
  }) =>
      Container(
        margin: EdgeInsets.only(top: 12.0),
        padding: EdgeInsets.only(left: 12.0, right: 12.0),
        decoration: (error ?? false)
            ? BoxDecoration(
                border: Border.all(color: Colors.red, width: 2.0),
                borderRadius: BorderRadius.circular(12.0))
            : null,
        child: TextField(
          controller: controller,
          onChanged: onChange,
          decoration: InputDecoration(
            hintText: hint,
            // suffixIcon: InkWell(
            //   borderRadius: BorderRadius.circular(24.0),
            //   onTap: () {
            //     setState(
            //       () {
            //         controller.clear();
            //       },
            //     );
            //   },
            //   child: Icon(Icons.clear, color: Colors.grey),
            // ),
          ),
        ),
      );

  Widget _copyButton(BuildContext context) => Tooltip(
        message: 'Click to copy password',
        child: TextButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: _keyController.text));
          },
          child: Text(
            'Click to copy',
          ),
        ),
      );
}
