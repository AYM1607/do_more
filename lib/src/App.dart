import 'package:flutter/material.dart';
import 'widgets/logo.dart';

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Do more',
      //home: Text('Start'),
      home: Scaffold(
        appBar: AppBar(
          title: Text('DO>'),
        ),
        body: Container(
          color: Colors.blue,
          child: Logo(),
        ),
      ),
    );
  }
}
