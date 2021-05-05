import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager_r1/consts/strings.dart';
import 'package:password_manager_r1/services/encryption.dart';
import 'package:password_manager_r1/ui/widgets/dialogs/info_dialog.dart';

class AdvancedSettings extends StatelessWidget {
  AdvancedSettings(
      {@required this.show,
      @required this.saltController,
      @required this.countController,
      @required this.onHeaderTap,
      @required this.autoSalt,
      @required this.onAutoSaltTap,
      @required this.defaultCount,
      @required this.onDefaultCountTap});

  final bool show;
  final TextEditingController saltController;
  final TextEditingController countController;
  final Function onHeaderTap; // setState(() => _showAdvanced = !_showAdvanced)
  final bool autoSalt;
  final Function(bool value) onAutoSaltTap;
  final bool defaultCount;
  final Function(bool value) onDefaultCountTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onHeaderTap,
      child: ExpansionPanelList(
        children: [
          ExpansionPanel(
              headerBuilder: (context, isExpanded) => Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text(
                      'Advanced',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              isExpanded: show,
              body: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    _saltInputField(context),
                    Padding(
                      padding: EdgeInsets.all(24.0),
                    ),
                    _countInputField(context),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _saltInputField(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Salt', style: Theme.of(context).textTheme.subtitle1),
              IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () =>
                      infoDialog(context, 'Salt', kSaltDescription))
            ],
          ),
          Row(
            children: [
              Checkbox(value: autoSalt, onChanged: onAutoSaltTap),
              Text('Use randomly generated salt (recommended)')
            ],
          ),
          TextField(
            controller: (autoSalt) ? TextEditingController() : saltController,
            enabled: !autoSalt,
            decoration: InputDecoration(hintText: 'Salt'),
          ),
        ],
      );

  Widget _countInputField(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Iteration count',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () => infoDialog(
                      context, 'Iteration count', kIterationCountDescription))
            ],
          ),
          Row(
            children: [
              Checkbox(value: defaultCount, onChanged: onDefaultCountTap),
              Text('Use default iteration count (${Encryption.DEFAULT_COUNT})')
            ],
          ),
          TextField(
            controller:
                (defaultCount) ? TextEditingController() : countController,
            enabled: !defaultCount,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(hintText: 'Iterations'),
          ),
        ],
      );
}
