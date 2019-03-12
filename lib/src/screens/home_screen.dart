import 'package:flutter/material.dart';

import '../resources/authService.dart';
import '../widgets/task_list_tile.dart';

class HomeScreen extends StatelessWidget {
  final _auth = authService;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: TaskListTile(),
    );
  }
}
