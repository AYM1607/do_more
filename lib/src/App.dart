import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/initial_loading_screen.dart';

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Do more',
      //home: Text('Start'),
      onGenerateRoute: routes,
      theme: ThemeData(
        canvasColor: Color.fromRGBO(23, 25, 29, 1.0),
        fontFamily: 'IBM Plex Sans',
      ),
    );
  }

  Route routes(RouteSettings settings) {
    final List<String> routeTokens = settings.name.split('/');
    print(routeTokens);
    if (settings.name == '/') {
      return MaterialPageRoute(
        builder: (BuildContext context) {
          return InitialLoadingScreen();
        },
      );
    } else if (routeTokens.first == 'login') {
      return MaterialPageRoute(
        builder: (BuildContext context) {
          return LoginScreen();
        },
      );
    } else if (routeTokens.first == 'home') {
      return MaterialPageRoute(builder: (BuildContext context) {
        return HomeScreen();
      });
    }
  }
}
