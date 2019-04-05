import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class InitialLoadingScreen extends StatelessWidget {
  /// An instance of the auth service.
  final AuthService _auth = authService;

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).canvasColor,
        child: FutureBuilder(
          future: Future.delayed(
            Duration(seconds: 2),
            () => 'Done',
          ),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              redirectUser(context);
            }
            return Center(
              child: Container(
                height: 150,
                width: 150,
                child: FlareActor(
                  'assets/animations/loading_logo.flr',
                  animation: 'Flip',
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Pushed a new route depending on the user status.
  ///
  /// Redirect to the home screen if there's a user stored locally, redirect
  /// to the login screen otherwise.
  void redirectUser(BuildContext context) async {
    final user = await _auth.currentUser;
    final routeToBePushed = user == null ? 'login/' : 'home/';
    Navigator.of(context).pushReplacementNamed(routeToBePushed);
  }
}
