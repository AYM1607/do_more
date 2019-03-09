import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Do more',
      //home: Text('Start'),
      home: LoginScreen(),
      theme: ThemeData(
        canvasColor: Color.fromRGBO(23, 25, 29, 1.0),
        fontFamily: 'IBM Plex Sans',
      ),
    );
  }
}
