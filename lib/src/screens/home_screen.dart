import 'dart:async';

import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../resources/authService.dart';
import '../resources/firestore_provider.dart';
import '../widgets/task_list_tile.dart';
import '../widgets/loading_indicator.dart';

class HomeScreen extends StatelessWidget {
  final _auth = authService;
  final _firestore = firestoreProvider;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: StreamBuilder(
        stream: _firestore.getUserTasks('mariano159357'),
        builder: (BuildContext context, AsyncSnapshot<List<TaskModel>> snap) {
          if (!snap.hasData) {
            return Center(
              child: LoadingIndicator(),
            );
          }
          return ListView(
            padding: EdgeInsets.all(0.0),
            children:
                snap.data.map((task) => TaskListTile(task: task)).toList(),
          );
        },
      ),
    );
  }
}
