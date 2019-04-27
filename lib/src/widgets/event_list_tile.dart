import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/event_model.dart';
import '../mixins/tile_mixin.dart';
import '../utils.dart' show kTileBigTextStyle, kBlueGradient, getColorFromEvent;
import '../widgets/action_button.dart';

class EventListTile extends StatelessWidget with Tile {
  final EventModel event;

  EventListTile({@required this.event}) : assert(event != null);

  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: .95,
      child: Container(
        height: 85,
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        event.name,
                        style: kTileBigTextStyle,
                      ),
                      _OcurranceIdicator(ocurrance: event.when),
                    ],
                  ),
                ],
              ),
            ),
            getResourcesButton(context),
            getPriorityIndicator(),
            getTasksIndicator(),
          ],
        ),
        decoration: tileDecoration(Theme.of(context).cardColor),
      ),
    );
  }

  Widget getResourcesButton(BuildContext context) {
    return Positioned(
      bottom: 8,
      right: 23,
      child: ActionButton(
        color: Colors.white,
        textColor: Colors.black,
        text: 'Resources',
        leadingIconData: FontAwesomeIcons.listAlt,
        onPressed: () => Navigator.of(context).pushNamed('event/${event.name}'),
      ),
    );
  }

  Widget getPriorityIndicator() {
    final color = getColorFromEvent(event);
    return Row(
      children: <Widget>[
        Spacer(),
        Container(
          width: 15,
          decoration: tileDecoration(color),
        ),
      ],
    );
  }

  Widget getTasksIndicator() {
    return Positioned(
      bottom: 75,
      right: -10,
      child: Container(
        child: Center(
          child: Text(
            '${event.pendingTasks}',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        width: 30,
        height: 20,
        decoration: BoxDecoration(
          gradient: kBlueGradient,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class _OcurranceIdicator extends StatelessWidget {
  static const kDayLetters = ['M', 'T', 'W', 'Th', 'F'];
  // A list that visually represents when an event occurs.
  final List<bool> ocurrance;

  _OcurranceIdicator({@required this.ocurrance})
      : assert(ocurrance != null),
        assert(ocurrance.length == 5);

  Widget build(BuildContext context) {
    List<Widget> rowChildren = [];

    for (int i = 0; i < 5; i++) {
      rowChildren.add(
        Container(
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            color: ocurrance[i] ? Colors.white : Colors.grey,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Center(
            child: Text(
              kDayLetters[i],
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
      if (i != 4) {
        rowChildren.add(
          SizedBox(
            width: 5,
          ),
        );
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: rowChildren,
    );
  }
}
