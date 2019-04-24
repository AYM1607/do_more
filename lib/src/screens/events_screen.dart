import 'package:flutter/material.dart' hide AppBar;

import '../blocs/events_bloc.dart';
import '../models/event_model.dart';
import '../widgets/app_bar.dart';
import '../widgets/event_list_tile.dart';
import '../widgets/populated_drawer.dart';

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  /// An instance of the bloc for this screen.
  final EventsBloc bloc = EventsBloc();

  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.userStream,
      builder: (context, AsyncSnapshot<FirebaseUser> userSnap) {
        String userAvatarUrl, userDisplayName = '', userEmail = '';

        if (userSnap.hasData) {
          userAvatarUrl = userSnap.data.photoUrl;
          userDisplayName = userSnap.data.displayName;
          userEmail = userSnap.data.email;
        }

        return Scaffold(
          drawer: PopulatedDrawer(
            userAvatarUrl: userAvatarUrl,
            userDisplayName: userDisplayName,
            userEmail: userEmail,
            selectedScreen: Screen.events,
          ),
          appBar: AppBar(
            title: 'My Events',
            hasDrawer: true,
          ),
          body: ListView(
            padding: EdgeInsets.only(top: 15),
            children: <Widget>[
              EventListTile(
                event: EventModel(
                  id: '1',
                  name: 'Math',
                  pendigTasks: 3,
                  media: <String>[],
                  when: <bool>[],
                  highPriority: 2,
                  mediumPriority: 1,
                  lowPriority: 0,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
