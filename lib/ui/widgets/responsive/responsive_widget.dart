import 'package:flutter/material.dart';
import 'package:password_manager_r1/consts/responsive.dart';

class ResponsiveWidget extends StatelessWidget {
  ResponsiveWidget({this.mobile, this.tablet, this.desktop});
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // if (constraints.maxWidth >= TABLET_MIN_WIDTH && tablet != null) {
        //   return tablet;
        // }

        if (constraints.maxWidth >= DESKTOP_MIN_WIDTH && desktop != null) {
          return desktop;
        } else if (mobile != null) {
          return mobile;
        }
        return Container();
      },
    );
  }
}
