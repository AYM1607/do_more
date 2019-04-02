import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/initial_loading_screen.dart';
import 'screens/login_screen.dart';
import 'screens/new_image_screen.dart';
import 'screens/new_task_screen.dart';

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Do more',
      //home: Text('Start'),
      onGenerateRoute: routes,
      theme: ThemeData(
        // Accent color is set to be used by the floating action button.
        accentColor: Color(0xFF707070),
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
          return NewTaskScreen();
        },
      );
    } else if (routeTokens.first == 'newImage') {
      return MaterialPageRoute(
        builder: (BuildContext context) {
          return NewImageScreen();
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
