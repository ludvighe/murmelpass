import 'package:flutter/material.dart';
import 'package:password_manager_r1/consts/responsive.dart';
import 'package:password_manager_r1/models/password_data.dart';
import 'package:password_manager_r1/providers/master_password.dart';
import 'package:password_manager_r1/providers/password_data_provider.dart';
import 'package:password_manager_r1/providers/user_provider.dart';
import 'package:password_manager_r1/ui/pages/password_edit_page/password_edit_page.dart';
import 'package:password_manager_r1/ui/widgets/murmel_logo.dart';
import 'package:provider/provider.dart';

class PasswordCard extends StatelessWidget {
  PasswordCard(this.passwordData);
  final PasswordData passwordData;
  final pwWarnings = [-90, -180];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<PasswordDataProvider>(context, listen: false).current =
            passwordData;
        if (MediaQuery.of(context).size.width < DESKTOP_MIN_WIDTH)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PasswordEditPage(),
            ),
          );
      },
      child: Tooltip(
        message: passwordData.title,
        child: Container(
          margin: EdgeInsets.all(12.0),
          height: 50.0,
          child: Row(
            children: [
              Expanded(child: MurmelLogo()),
              Expanded(
                flex: 3,
                child: Text(
                  passwordData.title,
                  style: Theme.of(context).textTheme.headline5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 3,
                child: _dateColumn(),
              ),
              Expanded(
                child: _copyButton(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateColumn() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              'Last used: ${passwordData.lastUsedAsString()}',
              style: TextStyle(color: Colors.grey),
              overflow: TextOverflow.clip,
            ),
          ),
          Expanded(
            child: Text('Created: ${passwordData.createdAsString()}',
                style: TextStyle(
                    color: (passwordData.created
                                .difference(DateTime.now())
                                .inDays <=
                            pwWarnings[1])
                        ? Colors.red
                        : (passwordData.created
                                    .difference(DateTime.now())
                                    .inDays <=
                                pwWarnings[0])
                            ? Colors.amber
                            : Colors.grey)),
          )
        ],
      );

  Widget _copyButton(BuildContext context) => Padding(
        padding: EdgeInsets.only(left: 12.0, right: 12.0),
        child: Tooltip(
          message: 'Click to copy password',
          child: IconButton(
              onPressed: () {
                passwordData.lastUsed = DateTime.now();
                Provider.of<PasswordDataProvider>(context, listen: false)
                    .generatePassword(
                  masterPassword:
                      Provider.of<MasterPassword>(context, listen: false)
                          .masterPassword,
                  passwordData: passwordData,
                  user: Provider.of<UserProvider>(context, listen: false).user,
                  copyToClipboard: true,
                );
              },
              icon: Icon(
                Icons.copy,
              )),
        ),
      );
}
