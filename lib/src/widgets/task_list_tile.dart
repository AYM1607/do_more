import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../utils.dart';

class TaskListTile extends StatelessWidget {
  final TaskModel task;
  static const _badgeHeight = 25.0;

  TaskListTile({@required this.task});

  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: .9,
      child: Container(
        height: 116,
        child: Stack(
          children: <Widget>[
            buildBadge(),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 9,
                ),
                buildTextSection(),
                Expanded(
                  flex: 5,
                  child: Center(
                    child: Text('section2'),
                  ),
                ),
                SizedBox(
                  width: 9,
                ),
              ],
            ),
          ],
        ),
        decoration: tileDecoration(context),
      ),
    );
  }

  Widget buildTextSection() {
    return Expanded(
      flex: 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: _badgeHeight + 4,
          ),
          Text(
            task.event,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            task.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBadge() {
    final badgeColor = getColorFromPriority(task.priority);
    return Container(
      alignment: Alignment.topLeft,
      width: 88,
      height: _badgeHeight,
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(14),
        ),
      ),
      child: Center(
        child: Text(task.getPriorityText(),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.white,
            )),
      ),
    );
  }

  BoxDecoration tileDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(8),
        bottomRight: Radius.circular(8),
      ),
    );
  }
}
