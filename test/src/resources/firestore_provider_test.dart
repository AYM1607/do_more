import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_more/src/models/event_model.dart';
import 'package:do_more/src/models/summary_model.dart';
import 'package:do_more/src/models/task_model.dart';
import 'package:do_more/src/models/user_model.dart';
import 'package:do_more/src/resources/firestore_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

main() {
  final task = TaskModel.sample();

  final event = EventModel(
    id: '1',
    name: 'An event',
    pendigTasks: 0,
    media: <String>[],
    when: <bool>[],
    highPriority: 0,
    mediumPriority: 0,
    lowPriority: 0,
  );

  final summary = SummaryModel();

  final user = UserModel(
    id: '123',
    tasks: <String>[],
    events: <String>[],
    pendingHigh: 0,
    pendingMedium: 0,
    pendingLow: 0,
    username: 'testUser',
    summary: summary,
  );

  group('FirestoreProvider', () {
    test('should create a user', () {
      final firestore = MockFirestore();
      final collection = MockCollectionReference();
      final document = MockDocumentReference();
      final provider = FirestoreProvider(firestore);

      when(firestore.collection('users')).thenReturn(collection);
      when(collection.document('123')).thenReturn(document);

      provider.createUser(user, '123');

      verify(document.setData(user.toFirestoreMap()));
    });

    test('should update the information of a user', () {
      final firestore = MockFirestore();
      final collection = MockCollectionReference();
      final document = MockDocumentReference();
      final provider = FirestoreProvider(firestore);

      when(firestore.collection('users')).thenReturn(collection);
      when(collection.document(user.id)).thenReturn(document);

      provider.updateUser(user.id, pendingHigh: 1);

      verify(document.setData({'pendingHigh': 1}, merge: true));
    });

    test('should listen to updates of a single user object', () {
      final firestore = MockFirestore();
      final collection = MockCollectionReference();
      final query = MockQuery();
      final querySnapshot = MockQuerySnapshot();
      final snapshot = MockDocumentSnapshot(user.toFirestoreMap());
      final snapshots = Stream.fromIterable([querySnapshot]);
      final provider = FirestoreProvider(firestore);

      when(firestore.collection('users')).thenReturn(collection);
      when(collection.where('username', isEqualTo: user.username))
          .thenReturn(query);
      when(query.snapshots()).thenAnswer((_) => snapshots);
      when(querySnapshot.documents).thenReturn([snapshot]);
      when(snapshot.documentID).thenReturn(user.id);

      expect(provider.getUserObservable(user.username), emits(user));
    });

    test('should create task', () {
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

    test('should delete a task', () {
      final firestore = MockFirestore();
      final collection = MockCollectionReference();
      final document = MockDocumentReference();
      final provider = FirestoreProvider(firestore);

      when(firestore.collection('tasks')).thenReturn(collection);
      when(collection.document(task.id)).thenReturn(document);
      when(document.delete()).thenAnswer((_) => Future<void>.value());

      provider.deleteTask(task.id);

      verify(document.delete());
    });

    test('should update a task', () {
      final firestore = MockFirestore();
      final collection = MockCollectionReference();
      final document = MockDocumentReference();
      final provider = FirestoreProvider(firestore);

      when(firestore.collection('tasks')).thenReturn(collection);
      when(collection.document(task.id)).thenReturn(document);

      provider.updateTask(task.id, done: true);

      verify(document.setData({'done': true}, merge: true));
    });

    group('should listen for updates in user\'s tasks', () {
      test('with an event specified', () {
        final firestore = MockFirestore();
        final collection = MockCollectionReference();
        final query = MockQuery();
        final snapshot = MockQuerySnapshot();
        final snapshots = Stream.fromIterable([snapshot]);
        final document = MockDocumentSnapshot(task.toFirestoreMap());
        final provider = FirestoreProvider(firestore);

        when(firestore.collection('tasks')).thenReturn(collection);
        when(collection.where('ownerUsername', isEqualTo: 'testUser'))
            .thenReturn(query);
        when(query.where('done', isEqualTo: false)).thenReturn(query);
        when(query.where('event', isEqualTo: 'testEvent')).thenReturn(query);
        when(query.snapshots()).thenAnswer((_) => snapshots);
        when(snapshot.documents).thenReturn([document]);
        when(document.documentID).thenReturn(task.id);

        expect(provider.getUserTasks('testUser', event: 'testEvent'),
            emits([task]));
      });

      test('with no event specified', () {
        final firestore = MockFirestore();
        final collection = MockCollectionReference();
        final query = MockQuery();
        final snapshot = MockQuerySnapshot();
        final snapshots = Stream.fromIterable([snapshot]);
        final document = MockDocumentSnapshot(task.toFirestoreMap());
        final provider = FirestoreProvider(firestore);

        when(firestore.collection('tasks')).thenReturn(collection);
        when(collection.where('ownerUsername', isEqualTo: 'testUser'))
            .thenReturn(query);
        when(query.where('done', isEqualTo: false)).thenReturn(query);
        when(query.snapshots()).thenAnswer((_) => snapshots);
        when(snapshot.documents).thenReturn([document]);
        when(document.documentID).thenReturn(task.id);

        expect(provider.getUserTasks('testUser'), emits([task]));
      });
    });

    test('should create event', () {
      final firestore = MockFirestore();
      final collection = MockCollectionReference();
      final provider = FirestoreProvider(firestore);

      when(firestore.collection('users/123/events')).thenReturn(collection);

      provider.addEvent('123', event);

      verify(collection.add(event.toFirestoreMap()));
    });

    test('should listen for updates to a single Event', () {
      final firestore = MockFirestore();
      final collection = MockCollectionReference();
      final snapshot = MockDocumentSnapshot(event.toFirestoreMap());
      final snapshots = Stream.fromIterable([snapshot]);
      final document = MockDocumentReference();
      final provider = FirestoreProvider(firestore);

      when(firestore.collection('users/123/events')).thenReturn(collection);
      when(collection.document(event.id)).thenReturn(document);
      when(document.snapshots()).thenAnswer((_) => snapshots);
      when(snapshot.documentID).thenReturn(event.id);

      expectLater(provider.getEventObservable('123', event.id), emits(event));
    });

    test('should delete an event', () {
      final firestore = MockFirestore();
      final document = MockDocumentReference();
      final provider = FirestoreProvider(firestore);

      when(firestore.document('users/123/events/${event.id}'))
          .thenReturn(document);
      when(document.delete()).thenAnswer((_) => Future<void>.value());

      provider.deleteEvent('123', event.id);

      verify(document.delete());
    });

    test('should update an event', () {
      final firestore = MockFirestore();
      final document = MockDocumentReference();
      final provider = FirestoreProvider(firestore);

      when(firestore.document('users/123/events/${event.id}'))
          .thenReturn(document);

      provider.updateEvent('123', event.id, name: 'new name');

      verify(document.setData({'name': 'new name'}, merge: true));
    });

    test('should listen for changes in user\'s events', () {
      final firestore = MockFirestore();
      final collection = MockCollectionReference();
      final snapshot = MockQuerySnapshot();
      final snapshots = Stream.fromIterable([snapshot]);
      final document = MockDocumentSnapshot(event.toFirestoreMap());
      final provider = FirestoreProvider(firestore);

      when(firestore.collection('users/123/events')).thenReturn(collection);
      when(collection.snapshots()).thenAnswer((_) => snapshots);
      when(snapshot.documents).thenReturn([document]);
      when(document.documentID).thenReturn(event.id);

      expect(provider.getUserEvents('123'), emits([event]));
    });
  });
}

class MockFirestore extends Mock implements Firestore {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockDocumentReference extends Mock implements DocumentReference {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {
  final Map<String, dynamic> data;

  MockDocumentSnapshot([this.data]);

  dynamic operator [](String key) => data[key];
}

class MockQuerySnapshot extends Mock implements QuerySnapshot {}

class MockQuery extends Mock implements Query {}
