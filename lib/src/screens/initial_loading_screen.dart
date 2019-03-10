import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../resources/authService.dart';

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
              child: CupertinoActivityIndicator(),
            );
          },
        ),
      ),
    );
  }
}
