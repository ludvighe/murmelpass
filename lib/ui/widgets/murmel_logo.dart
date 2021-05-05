import 'dart:math';

import 'package:flutter/material.dart';
import 'package:password_manager_r1/providers/async_provider.dart';
import 'package:provider/provider.dart';

class MurmelLogo extends StatefulWidget {
  @override
  _MurmelLogoState createState() => _MurmelLogoState();
}

class _MurmelLogoState extends State<MurmelLogo>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AsyncProvider>(builder: (context, state, child) {
      if (state.loading) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
      return AnimatedBuilder(
        animation: _controller.view,
        builder: (context, child) => Transform.rotate(
          angle: _controller.value * 2 * pi,
          child: child,
        ),
        child: Image.asset('assets/images/murmel.png'),
      );
    });
  }
}
