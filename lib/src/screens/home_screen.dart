import 'package:flutter/material.dart';

import '../resources/authService.dart';

class HomeScreen extends StatelessWidget {
  final _auth = authService;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: MaterialButton(
        onPressed: () => _auth.signOut(),
        child: Text(
          'SignOut',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
