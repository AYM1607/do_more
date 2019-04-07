import 'package:flutter/material.dart';

import '../blocs/event_bloc.dart';
import '../widgets/custom_app_bar.dart';

class EventScreen extends StatefulWidget {
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final EventBloc bloc = EventBloc();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '',
      ),
    );
  }

  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
