import 'package:flutter/material.dart' hide AppBar;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../blocs/events_bloc.dart';
import '../models/event_model.dart';
import '../widgets/app_bar.dart';
import '../widgets/event_list_tile.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/populated_drawer.dart';

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  /// An instance of the bloc for this screen.
  final EventsBloc bloc = EventsBloc();

  initState() {
    super.initState();
    bloc.fetchEvents();
  }

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
          floatingActionButton: FloatingActionButton(
            child: Icon(FontAwesomeIcons.plus),
            onPressed: () => Navigator.of(context).pushNamed('newEvent/'),
          ),
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
          body: StreamBuilder(
            stream: bloc.events,
            builder: (context, AsyncSnapshot<List<EventModel>> eventsSnap) {
              if (!eventsSnap.hasData) {
                return Center(
                  child: LoadingIndicator(),
                );
              }
              return buildList(eventsSnap.data);
            },
          ),
        );
      },
    );
  }

  Widget buildList(List<EventModel> events) {
    return ListView(
      padding: EdgeInsets.only(top: 15),
      children: events
          .map(
            (event) => Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: EventListTile(
                    event: event,
                  ),
                ),
          )
          .toList(),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
