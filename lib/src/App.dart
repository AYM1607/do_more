import 'package:flutter/material.dart';
import './models/event_model.dart';
import './models/summary_model.dart';
import './models/task_model.dart';
import './models/user_model.dart';
import './resources/google_login_provider.dart';

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Do more',
      //home: Text('Start'),
      home: Scaffold(
        appBar: AppBar(
          title: Text('DO>'),
        ),
        body: Text('Tasks'),
      ),
    );
  }
}
