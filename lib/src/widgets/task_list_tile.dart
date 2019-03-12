import 'package:flutter/material.dart';

import '../models/task_model.dart';

class TaskListTile extends StatelessWidget {
  final TaskModel task;

  TaskListTile({@required this.task});

  Widget build(BuildContext context) {
    String getTaskPriority() {}

    return FractionallySizedBox(
      widthFactor: .9,
      child: Container(
        height: 116,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 88,
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(14),
                  ),
                ),
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
      ),
    );
  }
}
