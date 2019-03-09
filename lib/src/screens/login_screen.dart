import 'package:flutter/material.dart';

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
              flex: 3,
            ),
            Expanded(
              child: Center(
                child: GradientButton(
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
      children: <Widget>[
        Text(
          'LOGIN',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
