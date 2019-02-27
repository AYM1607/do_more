import 'package:flutter/material.dart';

import './models/event_model.dart';
import './models/task_model.dart';
import './models/user_model.dart';
import './resources/firestore_provider.dart';

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    final fire = FirestoreProvider();
    return MaterialApp(
      title: 'Do more',
      //home: Text('Start'),
      home: Scaffold(
        appBar: AppBar(
          title: Text('DO>'),
        ),
        body: StreamBuilder(
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
        ),
      ),
    );
  }
}
