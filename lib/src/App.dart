import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './models/event_model.dart';
import './models/summary_model.dart';
import './models/task_model.dart';
import './models/user_model.dart';
import './resources/google_sign_in_provider.dart';

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    final gLogin = GoogleSignInProvider();
    return MaterialApp(
      title: 'Do more',
      //home: Text('Start'),
      home: Scaffold(
        appBar: AppBar(
          title: Text('DO>'),
        ),
        body: Column(
          children: <Widget>[
            Text('Tasks'),
            MaterialButton(
              child: Text('Google Sign In'),
              onPressed: gLogin.signIn,
            ),
            MaterialButton(
              child: Text('Google Current User'),
              onPressed: gLogin.getCurrentUser,
            ),
            MaterialButton(
              child: Text('Google Sign out'),
              onPressed: gLogin.signOut,
            ),
            StreamBuilder(
              stream: gLogin.onAuthStateChange,
              builder:
                  (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
                if (!snapshot.hasData) {
                  return Text('no user');
                }
                return Text(snapshot.data.displayName);
              },
            ),
          ],
        ),

        /* StreamBuilder(
          stream: fire.getEvent('vBOvtmTeC8iPg8L4Hixh', '-LZReccofbHpw9UfOTMk'),
          builder:
              (BuildContext context, AsyncSnapshot<EventModel> userSnapshot) {
            if (!userSnapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final children = <Widget>[
              MaterialButton(
                onPressed: () {
                  final task = TaskModel(
                    ownerUsername: 'mariano159357',
                    text: 'I dont know what to put',
                    priority: 2,
                    done: false,
                    event: 'Math',
                  );

                  final event = EventModel(
                    name: 'Langs and trans',
                    tasks: <String>[],
                    highPriority: 0,
                    mediumPriority: 0,
                    lowPriority: 0,
                    media: <String>[],
                    when: <bool>[],
                    pendigTasks: 0,
                  );

                  fire.updateEvent(
                    'vBOvtmTeC8iPg8L4Hixh',
                    '-LZReccofbHpw9UfOTMk',
                    name: 'Custom Task',
                  );
                },
                child: Text('Add task'),
              ),
            ];
            //children.add(Text(userSnapshot.data.text));

            //userSnapshot.data.forEach((EventModel task) {
            //  children.add(Text(task.name));
            //});

            children.add(Text(userSnapshot.data.name));

            return Column(
              children: children,
            );
          },
        ), */
      ),
    );
  }
}
