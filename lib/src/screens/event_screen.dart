import 'package:flutter/material.dart';

import '../utils.dart';
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

class _EventScreenState extends State<EventScreen>
    with SingleTickerProviderStateMixin {
  EventBloc bloc;
  TabController _tabController;
  initState() {
    super.initState();
    bloc = EventBloc(eventName: widget.eventName);
    _tabController = TabController(vsync: this, length: 2);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.eventName,
        bottom: TabBar(
          controller: _tabController,
          tabs: <Tab>[
            Tab(
              text: 'tab1',
            ),
            Tab(
              text: 'tab2',
            ),
          ],
        ),
      ),
    );
  }

  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
