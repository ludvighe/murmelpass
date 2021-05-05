import 'package:flutter/material.dart';

void infoDialog(BuildContext context, String title, String info) {
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text(title),
            content: SizedBox(width: 250, child: Text(info)),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Got it'))
            ],
          ));
}

Future<bool> yesNoDialog({BuildContext context, String title, String action}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text(title),
            content: Text('Are you sure you want to $action?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('No')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text('Yes'))
            ],
          ));
}

void networkFailureDialog(BuildContext context, String action) {
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text('Network failure'),
            content: Text(
                'Could not $action. Please check your internet connection. Otherwise this might be because the servers are currently down.'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Got it'))
            ],
          ));
}
