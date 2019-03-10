import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class InitialLoadingScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).canvasColor,
        child: Center(
          child: CupertinoActivityIndicator(),
        ),
      ),
    );
  }
}
