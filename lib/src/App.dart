import 'package:flutter/material.dart';

import './models/user_model.dart';
import './resources/firebase_provider.dart';

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    final fire = FirebaseProvider();
    return MaterialApp(
      title: 'Do more',
      //home: Text('Start'),
      home: Scaffold(
        appBar: AppBar(
          title: Text('DO>'),
        ),
        body: StreamBuilder(
          stream: fire.getUser('mariano159357'),
          builder:
              (BuildContext context, AsyncSnapshot<UserModel> userSnapshot) {
            if (!userSnapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              children: <Widget>[
                Text('${userSnapshot.data.pendingHigh}'),
                MaterialButton(
                  onPressed: () {},
                  child: Text('Add task'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
