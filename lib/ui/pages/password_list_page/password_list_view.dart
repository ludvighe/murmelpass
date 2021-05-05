import 'package:flutter/material.dart';
import 'package:password_manager_r1/models/password_data.dart';
import 'package:password_manager_r1/ui/pages/password_list_page/password_card.dart';

class PasswordListView extends StatelessWidget {
  PasswordListView(this.passwordDataList);
  List<PasswordData> passwordDataList;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: passwordDataList.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) => PasswordCard(passwordDataList[index]),
    );
  }
}
