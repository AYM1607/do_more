import 'package:flutter/material.dart';

import '../widgets/logo.dart';

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
              flex: 4,
            ),
            Expanded(
              child: Text('Login Buton'),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
