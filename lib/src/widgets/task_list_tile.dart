import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/task_model.dart';
import '../utils.dart';
import '../widgets/action_button.dart';

/// A card that visually represents a task.
class TaskListTile extends StatelessWidget {
  /// Task model which this card represents.
  final TaskModel task;

  /// Function to be called when the "done" button is pressed.
  final VoidCallback onDone;

  /// Function to be called when the "edit" button is pressed.
  final VoidCallback onEdit;

  /// Function to be called when the "event" button is pressed.
  final VoidCallback onEventPressed;

  /// Height of the priority badge.
  ///
  /// Also used to calculate the padding for the first section.
  static const _badgeHeight = 25.0;

  /// Creates a card that represents a task.
  ///
  /// The task property cannot be null.
  /// The card has 3 buttons whose callback must be provided.
  TaskListTile({
    @required this.task,
    this.onDone,
    this.onEdit,
    this.onEventPressed,
  }) : assert(task != null);

  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: .95,
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
                buildButtonSection(),
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

  /// Builds the section that contains the task's event and its text.
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

  /// Builds the section that contains the 3 buttons for the tile.
  Widget buildButtonSection() {
    return Expanded(
      flex: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          ActionButton(
            onPressed: onDone,
            text: 'Done',
            trailingIconData: FontAwesomeIcons.checkCircle,
            color: Colors.white,
            textColor: Colors.black,
            radius: 14,
            width: 72,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ActionButton(
                onPressed: onEdit,
                text: 'Edit',
                leadingIconData: Icons.edit,
              ),
              SizedBox(
                width: 4,
              ),
              ActionButton(
                onPressed: onEventPressed,
                text: 'Event',
                leadingIconData: FontAwesomeIcons.calendar,
              )
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the badge that showcases the tasks priority.
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
