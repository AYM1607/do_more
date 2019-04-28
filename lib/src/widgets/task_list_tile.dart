import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../mixins/tile_mixin.dart';
import '../models/task_model.dart';
import '../utils.dart';
import '../widgets/action_button.dart';

/// A card that visually represents a task.
class TaskListTile extends StatelessWidget with Tile {
  /// Task model which this card represents.
  final TaskModel task;

  /// Function to be called when the "done" button is pressed.
  final VoidCallback onDone;

  /// Function to be called when the "edit" button is pressed.
  final VoidCallback onEditPressed;

  /// Function to be called when the "event" button is pressed.
  final VoidCallback onEventPressed;

  /// Function to be called when the "undo" button is pressed.
  final VoidCallback onUndo;

  /// Whether or not the event button should be hidden.
  final bool hideEventButton;

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
    this.onUndo,
    this.onEditPressed,
    this.onEventPressed,
    this.hideEventButton = false,
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
        decoration: tileDecoration(Theme.of(context).cardColor),
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
            style: kTileBigTextStyle,
          ),
          Text(
            task.text,
            style: kTileSubtitleStyle,
          ),
        ],
      ),
    );
  }

  /// Builds the section that contains the 3 buttons for the tile.
  Widget buildButtonSection() {
    final columnChildren = <Widget>[];
    if (task.done) {
      columnChildren.addAll(
        [
          SizedBox(
            height: 25,
          ),
          ActionButton(
            onPressed: onUndo,
            text: 'Undo',
            trailingIconData: FontAwesomeIcons.timesCircle,
            color: Colors.white,
            textColor: Colors.black,
            radius: 14,
            width: 72,
          ),
        ],
      );
    } else {
      final bottomRowChildren = <Widget>[];

      bottomRowChildren.add(
        ActionButton(
          onPressed: onEditPressed,
          text: 'Edit',
          leadingIconData: Icons.edit,
        ),
      );

      if (!hideEventButton) {
        bottomRowChildren.addAll([
          SizedBox(
            width: 4,
          ),
          ActionButton(
            onPressed: onEventPressed,
            text: 'Event',
            leadingIconData: FontAwesomeIcons.calendar,
          ),
        ]);
      }
      columnChildren.addAll(
        [
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
            children: bottomRowChildren,
          ),
        ],
      );
    }

    return Expanded(
      flex: 5,
      child: Column(
        mainAxisAlignment:
            task.done ? MainAxisAlignment.start : MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: columnChildren,
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
}
