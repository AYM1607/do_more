import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_more/src/models/event_model.dart';
import 'package:do_more/src/models/task_model.dart';
import 'package:do_more/src/resources/firestore_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

class MockFirestore extends Mock implements Firestore {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockDocumentReference extends Mock implements DocumentReference {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {
  final Map<String, dynamic> data;

  MockDocumentSnapshot([this.data]);

  dynamic operator [](String key) => data[key];
}

class MockQuerySnapshot extends Mock implements QuerySnapshot {}

main() {
  final task = TaskModel(
    id: '1',
    text: 'A task',
    done: false,
    ownerUsername: 'testUser',
    event: 'testEvent',
    priority: 1,
  );

  final event = EventModel(
    id: '1',
    name: 'An event',
    pendigTasks: 0,
    media: <String>[],
    tasks: <String>[],
    when: <bool>[],
    highPriority: 0,
    mediumPriority: 0,
    lowPriority: 0,
  );

  group('FirestoreProvider', () {
    test('should send task to firestore', () {
      final firestore = MockFirestore();
      final collection = MockCollectionReference();
      final provider = FirestoreProvider(firestore);

      when(firestore.collection('tasks')).thenReturn(collection);

      provider.addTask(task);

      verify(collection.add(task.toFirestoreMap()));
    });

    test('should listen for updates to a single Task', () {
      final firestore = MockFirestore();
      final collection = MockCollectionReference();
      final snapshot = MockDocumentSnapshot(task.toFirestoreMap());
      final snapshots = Stream.fromIterable([snapshot]);
      final document = MockDocumentReference();
      final provider = FirestoreProvider(firestore);

      when(firestore.collection('tasks')).thenReturn(collection);
      when(collection.document(task.id)).thenReturn(document);
      when(document.snapshots()).thenAnswer((_) => snapshots);
      when(snapshot.documentID).thenReturn(task.id);

      expectLater(provider.getTask('1'), emits(task));
    });
  });
}
