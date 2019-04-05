import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

import '../services/authService.dart';

class InitialLoadingScreen extends StatelessWidget {
  final AuthService _auth = authService;

  void redirectUser(BuildContext context) async {
    final user = await _auth.currentUser;
    final routeToBePushed = user == null ? 'login/' : 'home/';
    Navigator.of(context).pushReplacementNamed(routeToBePushed);
  }

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
}
