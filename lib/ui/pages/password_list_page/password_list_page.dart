import 'package:flutter/material.dart';
import 'package:password_manager_r1/consts/responsive.dart';
import 'package:password_manager_r1/models/password_data.dart';
import 'package:password_manager_r1/providers/master_password.dart';
import 'package:password_manager_r1/providers/password_data_provider.dart';
import 'package:password_manager_r1/providers/user_provider.dart';
import 'package:password_manager_r1/ui/pages/password_edit_page/password_edit_container.dart';
import 'package:password_manager_r1/ui/pages/password_edit_page/password_edit_page.dart';
import 'package:password_manager_r1/ui/pages/password_list_page/password_list_view.dart';
import 'package:password_manager_r1/ui/pages/password_list_page/search_field.dart';
import 'package:password_manager_r1/ui/widgets/dialogs/info_dialog.dart';
import 'package:password_manager_r1/ui/widgets/password_text_field.dart';
import 'package:provider/provider.dart';

class PasswordListPage extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  void _enterMasterPassword(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController pwController = TextEditingController()..text = '';
        return Dialog(
          child: SizedBox(
            height: 150,
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PasswordTextField(
                    controller: pwController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Provider.of<MasterPassword>(context, listen: false)
                              .masterPassword = pwController.text;
                          Navigator.pop(context);
                        },
                        child: Text('Confirm'),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
    Provider.of<PasswordDataProvider>(context, listen: false).trigger();
  }

  void _logout(BuildContext context) async {
    try {
      if (!await yesNoDialog(
          context: context, title: 'Logout', action: 'logout')) return;
      Provider.of<UserProvider>(context, listen: false).logout();
      Provider.of<PasswordDataProvider>(context, listen: false).current = null;
      Navigator.pop(context);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Align(alignment: Alignment.center, child: Text('Your passwords')),
        leading: IconButton(
            onPressed: () => _logout(context), icon: Icon(Icons.logout)),
        actions: [
          Tooltip(
            message: 'Create new password',
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Provider.of<PasswordDataProvider>(context, listen: false)
                    .current = null;
                if (MediaQuery.of(context).size.width < DESKTOP_MIN_WIDTH)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PasswordEditPage(),
                    ),
                  );
              },
            ),
          ),
          Tooltip(
            message: 'Re-enter master password',
            child: IconButton(
              onPressed: () => _enterMasterPassword(context),
              icon: Icon(Icons.lock),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 12.0, left: 24.0, right: 24.0),
        child: Consumer<PasswordDataProvider>(
          builder: (context, state, child) {
            List<PasswordData> passwordDataList =
                (_searchController.text == '' || _searchController.text == null)
                    ? state.passwordDataList
                    : state.passwordDataListFiltered(_searchController.text);
            return Column(
              children: [
                Expanded(
                  child: SearchField(
                    controller: _searchController,
                    onChanged: (value) => state.trigger(),
                    onClear: () {
                      _searchController.clear();
                      state.trigger();
                    },
                  ),
                ),
                Expanded(
                  flex: 15,
                  child: Row(
                    children: [
                      Expanded(
                        child: PasswordListView(passwordDataList),
                      ),
                      if (MediaQuery.of(context).size.width >=
                          DESKTOP_MIN_WIDTH)
                        Expanded(
                          child: PasswordEditContainer(),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
