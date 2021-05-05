// Sorry about the mess...
// TODO: Split up code => Make more readable

import 'package:flutter/material.dart';
import 'package:password_manager_r1/consts/responsive.dart';
import 'package:password_manager_r1/models/hash_length.dart';
import 'package:password_manager_r1/models/password_data.dart';
import 'package:password_manager_r1/providers/password_data_provider.dart';
import 'package:password_manager_r1/providers/user_provider.dart';
import 'package:password_manager_r1/ui/pages/password_edit_page/edit_options.dart/advanced_settings.dart';
import 'package:password_manager_r1/ui/widgets/dialogs/info_dialog.dart';
import 'package:provider/provider.dart';

class PasswordEditContainer extends StatefulWidget {
  @override
  _PasswordEditContainerState createState() => _PasswordEditContainerState();
}

class _PasswordEditContainerState extends State<PasswordEditContainer> {
  final TextEditingController _titleController = TextEditingController()
    ..text = '';
  final TextEditingController _saltController = TextEditingController()
    ..text = '';
  final TextEditingController _countController = TextEditingController()
    ..text = '1';
  int _length = 16;
  bool _autoSalt = true;
  bool _defaultCount = true;
  bool _showAdvanced = false;

  PasswordData current;

  // bool _hasChanged = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Provider.of<PasswordDataProvider>(context, listen: false).current = null;
    _titleController.dispose();
    _saltController.dispose();
    _countController.dispose();
    super.dispose();
  }

  void _onRevert({bool ask = true}) async {
    bool revert;
    if (ask) {
      try {
        revert = await yesNoDialog(
                context: context,
                title: 'Revert changes',
                action: 'revert changes') ??
            false;
      } catch (e) {}
    }
    if (revert ?? true) {
      try {
        setState(() {
          try {
            _titleController.text = current.title;
            _saltController.text = current.salt;
            _countController.text = current.count.toString();
            _length = current.length.toInt();
            _autoSalt = false;
            _defaultCount = false;
          } catch (e) {
            _titleController.text = '';
            _saltController.text = '';
            _countController.text = '16';
            _length = 16;
            _autoSalt = true;
            _defaultCount = true;
          }
        });
      } catch (e) {}
    }
  }

  void _onSave() async {
    // Checking input before saving
    bool titlePassed = true;
    bool saltPassed = true;
    bool countPassed = true;
    String message = '';
    if (_titleController.text == null || _titleController.text == '') {
      message += '\n- Title is not valid.';
      titlePassed = false;
    }
    if (!_autoSalt &&
        (_saltController.text == null || _saltController.text == '')) {
      message += '\n- Salt is not valid.';
      saltPassed = false;
    }
    if (!_defaultCount &&
        (_countController.text == null || _countController.text == '')) {
      message += '\n- Iteration count is not valid.';
      countPassed = false;
    }
    if (!titlePassed || !saltPassed || !countPassed) {
      infoDialog(context, 'Couldn\'t save password', message);
    } else {
      // Saving
      if (Provider.of<PasswordDataProvider>(context, listen: false).current !=
          null) {
        try {
          if (!await yesNoDialog(
              context: context,
              title: 'Save',
              action: 'update saved password')) return;

          current.title = _titleController.text;
          current.salt = (_autoSalt) ? null : _saltController.text;
          current.count =
              (_defaultCount) ? null : int.parse(_countController.text);
          current.length = HashLength.fromInt(_length);
          try {
            Provider.of<PasswordDataProvider>(context, listen: false).update(
                user: Provider.of<UserProvider>(context, listen: false).user,
                passwordData: current);
          } catch (e) {
            print(e.toString());
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('Could not update password'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Darn it! Oh, well...'),
                  )
                ],
              ),
            );
          }
        } catch (e) {}
      } else {
        try {
          await Provider.of<PasswordDataProvider>(context, listen: false).add(
              user: Provider.of<UserProvider>(context, listen: false).user,
              title: _titleController.text,
              salt: (_autoSalt) ? null : _saltController.text,
              count: (_defaultCount) ? null : int.parse(_countController.text),
              length: _length);
        } catch (e) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Could not create password'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Darn it! Oh, well...'),
                )
              ],
            ),
          );
        }
      }
    }
  }

  void _onDelete() async {
    if (await yesNoDialog(
        context: context,
        title: 'Delete password',
        action: 'delete password')) {
      Provider.of<PasswordDataProvider>(context, listen: false).remove(
        user: Provider.of<UserProvider>(context, listen: false).user,
        passwordData:
            Provider.of<PasswordDataProvider>(context, listen: false).current,
      );
      Provider.of<PasswordDataProvider>(context, listen: false).current = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PasswordDataProvider>(
      builder: (context, state, child) {
        if (state.current == null && current == null) {
          // _onRevert(ask: false);
          current = PasswordData(
              title: _titleController.text,
              salt: _saltController.text,
              count: int.parse(_countController.text),
              length: HashLength.fromInt(_length));
          _autoSalt = true;
          _defaultCount = true;
        }
        if (state.current != current) {
          current = state.current;
          _onRevert(ask: false);
        }
        return Container(
          padding: EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: (MediaQuery.of(context).size.width < DESKTOP_MIN_WIDTH)
                ? Theme.of(context).scaffoldBackgroundColor
                : Colors.transparent,
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(),
            // boxShadow: [
            //   BoxShadow(
            //       blurRadius: 12.0, spreadRadius: 1.0, offset: Offset(5, 5))
            // ],
          ),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (state.current == null)
                        ? 'Create new password'
                        : 'Editing password',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  IconButton(
                    tooltip: 'Revert changes',
                    onPressed: () {
                      setState(() {
                        _onRevert(ask: true);
                      });
                    },
                    icon: Icon(
                      Icons.settings_backup_restore,
                      size: 36.0,
                    ),
                  ),
                ],
              ),
              if (state.current != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.current.title,
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    Text(
                      '#${state.current.id}',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
              Padding(padding: EdgeInsets.all(12.0)),
              _titleInputField(),
              Padding(padding: EdgeInsets.all(12.0)),
              _lengthSelector(),
              Padding(padding: EdgeInsets.all(24.0)),
              // ----------
              // if (state.current != null)
              if (state.current != null)
                AdvancedSettings(
                  show: _showAdvanced,
                  saltController: _saltController,
                  countController: _countController,
                  onHeaderTap: () => setState(() {
                    _showAdvanced = !_showAdvanced;
                  }),
                  autoSalt: _autoSalt,
                  onAutoSaltTap: (bool value) {
                    setState(() {
                      _autoSalt = value;
                    });
                  },
                  defaultCount: _defaultCount,
                  onDefaultCountTap: (bool value) {
                    setState(() {
                      _defaultCount = value;
                    });
                  },
                ),
              // ----------
              Padding(padding: EdgeInsets.all(12.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: (state.current != null) ? _onDelete : null,
                    icon: Icon(
                      Icons.delete,
                    ),
                    iconSize: 32.0,
                    color: Theme.of(context).errorColor,
                    tooltip: 'Delete',
                  ),
                  IconButton(
                    onPressed: _onSave,
                    icon: Icon(
                      Icons.save,
                    ),
                    iconSize: 32.0,
                    color: Theme.of(context).accentColor,
                    tooltip: 'Save',
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _titleInputField() => TextFormField(
        controller: _titleController,
        decoration: InputDecoration(labelText: 'Title'),
      );

  Widget _lengthSelector() {
    List items = [16, 32, 64, 128, 256];
    return Row(
      children: [
        Text(
          'Length of password: ',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        DropdownButton(
          items: items
              .map((e) => DropdownMenuItem(
                    child: Text('$e characters'),
                    value: e,
                  ))
              .toList(),
          value: _length,
          onChanged: (value) => setState(() {
            _length = value;
          }),
        ),
      ],
    );
  }
}
