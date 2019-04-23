import 'package:flutter/material.dart' hide AppBar;

import '../widgets/app_bar.dart';
import '../widgets/populated_drawer.dart';

class EventsScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: PopulatedDrawer(
        selectedScreen: Screen.events,
      ),
      appBar: AppBar(
        title: 'My Events',
        hasDrawer: true,
      ),
    );
  }
}
