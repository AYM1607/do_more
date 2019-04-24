import 'package:flutter/material.dart';

import '../models/event_model.dart';
import '../mixins/tile_mixin.dart';
import '../utils.dart';

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
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        event.name,
                        style: kTileBigTextStyle,
                      ),
                    ],
                  ),
                  Column(),
                ],
              ),
            ),
          ],
        ),
        decoration: tileDecoration(context),
      ),
    );
  }
}
