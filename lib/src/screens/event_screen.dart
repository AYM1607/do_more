import 'package:flutter/material.dart';

import '../blocs/event_bloc.dart';
import '../widgets/custom_app_bar.dart';

class EventScreen extends StatefulWidget {
  /// The name of the event this screenn is showing.
  final String eventName;

  EventScreen({
    @required this.eventName,
  });

  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  EventBloc bloc;

  initState() {
    super.initState();
    bloc = EventBloc(eventName: widget.eventName);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.eventName,
      ),
    );
  }

  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
