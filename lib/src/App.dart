import 'package:flutter/material.dart';

import 'screens/archive_screen.dart';
import 'screens/event_screen.dart';
import 'screens/events_screen.dart';
import 'screens/home_screen.dart';
import 'screens/initial_loading_screen.dart';
import 'screens/login_screen.dart';
import 'screens/new_event_screen.dart';
import 'screens/new_image_screen.dart';
import 'screens/task_screen.dart';

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Do more',
      //home: Text('Start'),
      onGenerateRoute: routes,
      theme: ThemeData(
        // Accent color is set to be used by the floating action button.
        accentColor: Color(0xFF707070),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        canvasColor: Color.fromRGBO(23, 25, 29, 1.0),
        cardColor: Color.fromRGBO(36, 39, 44, 1.0),
        cursorColor: Color.fromRGBO(112, 112, 112, 1),
        fontFamily: 'IBM Plex Sans',
      ),
    );
  }

  Route routes(RouteSettings settings) {
    final List<String> routeTokens = settings.name.split('/');
    print(routeTokens);
    if (routeTokens.first == 'login') {
      return MaterialPageRoute(
        builder: (BuildContext context) {
          return LoginScreen();
        },
      );
    } else if (routeTokens.first == 'home') {
      return MaterialPageRoute(
        builder: (BuildContext context) {
          return HomeScreen();
        },
      );
    } else if (routeTokens.first == 'newTask') {
      return MaterialPageRoute(
        builder: (BuildContext context) {
          return TaskScreen();
        },
      );
    } else if (routeTokens.first == 'editTask') {
      return MaterialPageRoute(
        builder: (BuildContext context) {
          return TaskScreen(
            isEdit: true,
            taskId: routeTokens[1],
          );
        },
      );
    } else if (routeTokens.first == 'newImage') {
      String eventName;
      if (routeTokens.length > 1) {
        eventName = routeTokens[1];
      }
      return MaterialPageRoute(
        builder: (BuildContext context) {
          return NewImageScreen(
            defaultEventName: eventName,
          );
        },
      );
    } else if (routeTokens.first == 'event') {
      return MaterialPageRoute(
        builder: (BuildContext context) {
          return EventScreen(
            eventName: routeTokens[1],
          );
        },
      );
    } else if (routeTokens.first == 'events') {
      return MaterialPageRoute(
        builder: (BuildContext context) {
          return EventsScreen();
        },
      );
    } else if (routeTokens.first == 'newEvent') {
      return MaterialPageRoute(
        builder: (BuildContext contex) {
          return NewEventScreen();
        },
      );
    } else if (routeTokens.first == 'archive') {
      return MaterialPageRoute(
        builder: (BuildContext context) {
          return ArchiveScreen();
        },
      );
    }
    // Default route.
    return MaterialPageRoute(
      builder: (BuildContext context) {
        return InitialLoadingScreen();
      },
    );
  }
}
