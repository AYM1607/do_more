import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/logo.dart';
import '../widgets/gradient_button.dart';

class LoginScreen extends StatelessWidget {
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
                child: GradientButton(
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
