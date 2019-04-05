import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../services/auth_service.dart';
import '../widgets/logo.dart';
import '../widgets/gradient_touchable_container.dart';

class LoginScreen extends StatelessWidget {
  final _authService = authService;

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).canvasColor,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Logo(),
              ),
              flex: 2,
            ),
            Expanded(
              child: Center(
                child: GradientTouchableContainer(
                  onTap: () => onLoginButtonTap(context),
                  height: 50,
                  width: 310,
                  radius: 25,
                  child: getButtonBody(),
                ),
              ),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onLoginButtonTap(BuildContext context) async {
    final user = await _authService.googleLoginAndSignup();
    if (user != null) {
      Navigator.of(context).pushReplacementNamed('home/');
    }
  }

  Widget getButtonBody() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'LOGIN',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Icon(
          FontAwesomeIcons.google,
          color: Colors.white,
          size: 24,
        ),
      ],
    );
  }
}
