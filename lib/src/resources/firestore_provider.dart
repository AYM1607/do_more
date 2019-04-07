import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import '../models/event_model.dart';
import '../models/user_model.dart';
import '../models/summary_model.dart';
import '../models/task_model.dart';

/// A connection to the Cloud Firestore database
///
/// Implempents CRUD operations for users, tasks and events.
class FirestoreProvider {
  final Firestore _firestore;

  FirestoreProvider([Firestore firestore])
      : _firestore = firestore ?? Firestore.instance {
    _firestore.settings(timestampsInSnapshotsEnabled: true);
  }
  //-----------------------User related operations------------------------------

  /// Returns a stream of [UserModel].
  Observable<UserModel> getUserObservable(String username) {
    final mappedStream = _firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .snapshots()
        .map(
      (QuerySnapshot snapshot) {
        if (snapshot.documents.isEmpty) {
          return null;
        }
        final userSnapshot = snapshot.documents.first;
        return UserModel.fromFirestore(
          userSnapshot.data,
          id: userSnapshot.documentID,
        );
      },
    );

    return Observable(mappedStream);
  }

  /// Returns a [UserModel].
  /// Only one out of id or username can be provided, if both are provided id
  /// will have higher priority.
  Future<UserModel> getUser({String id, String username}) async {
    DocumentSnapshot documentSnapshot;
    if (id != null) {
      documentSnapshot = await _firestore.document('users/$id').get();
    } else {
      final querySnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .getDocuments();
      documentSnapshot = querySnapshot.documents.first;
    }
    return UserModel.fromFirestore(
      documentSnapshot.data,
      id: documentSnapshot.documentID,
    );
  }

  /// Creates a new user in Firestore.
  Future<void> createUser(UserModel user, String uid) async {
    try {
      final dataMap = user.toFirestoreMap();
      final documentReference = _firestore.collection('users').document(uid);
      await documentReference.setData(dataMap);
    } catch (e) {
      print('Error creating user: $e');
    }
  }

  /// Verifies if a user with the given username is already in the database.
  Future<bool> userExists(String username) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .getDocuments();
    return querySnapshot.documents.length > 0;
  }

  /// Updates a user's data in Firestore.
  ///
  /// Updates are only pushed if at least one property is provided.
  Future<void> updateUser(
    String id, {
    List<String> tasks,
    List<String> events,
    SummaryModel summary,
    int pendingHigh,
    int pendingMedium,
    int pendingLow,
  }) async {
    final newData = <String, dynamic>{
      'tasks': tasks,
      'events': events,
      'summary': summary,
      'pendingHigh': pendingHigh,
      'pendingMedium': pendingMedium,
      'pendingLow': pendingLow,
    };
    newData.removeWhere((key, value) => value == null);

    if (newData.isEmpty) {
      return;
    }

    try {
      final documentReference = _firestore.collection('users').document(id);
      await documentReference.setData(newData, merge: true);
    } catch (e) {
      print('Error trying to update user data: $e');
    }
  }

  //-------------------------Task related operations----------------------------

  /// Adds a task to firestore.
  Future<void> addTask(TaskModel task) async {
    try {
      final dataMap = task.toFirestoreMap();
      await _firestore.collection('tasks').add(dataMap);
    } catch (e) {
      print('Error adding task to firestore: $e');
    }
  }

  /// Returns a Stream of a single task from an id.
  Observable<TaskModel> getTaskObservable(String id) {
    final mappedStream =
        _firestore.collection('tasks').document(id).snapshots().map(
      (DocumentSnapshot snapshot) {
        return TaskModel.fromFirestore(
          snapshot.data,
          id: snapshot.documentID,
        );
      },
    );

    return Observable(mappedStream);
  }

  //TODO: Add tests for this method.
  /// Returns a task from an id.
  Future<TaskModel> getTask(String id) async {
    final documentSnapshot = await _firestore.document('tasks/$id').get();
    return TaskModel.fromFirestore(
      documentSnapshot.data,
      id: documentSnapshot.documentID,
    );
  }

  /// Deletes a task from firestore.
  Future<void> deleteTask(String id) async {
    try {
      final documentReference = _firestore.collection('tasks').document(id);
      await documentReference.delete();
    } catch (e) {
      print('Error deleting task from firestore: $e');
    }
  }

  /// Updates a task in firestore.
  ///
  /// Only the [text], [priority] and [done] attributes can be update.
  /// Provide at least one of these values or this operation won't have any
  /// effect.
  Future<void> updateTask(
    String id, {
    String text,
    int priority,
    bool done,
  }) async {
    final newData = <String, dynamic>{
      'text': text,
      'priority': priority,
      'done': done,
    };
    newData.removeWhere((key, value) => value == null);

    // No need to call firestore if there's no new data to update.
    if (newData.isEmpty) {
      return;
    }

    try {
      final documentReference = _firestore.collection('tasks').document(id);
      await documentReference.setData(newData, merge: true);
    } catch (e) {
      print('Error updating task in firestore: $e');
    }
  }

  /// Returns a stream of [List<Task>] that correspond to a particular user.
  ///
  /// The [event] parameter is used to query tasks that are part of a certain
  /// event.
  Observable<List<TaskModel>> getUserTasks(String username, {String event}) {
    Query query = _firestore
        .collection('tasks')
        .where('ownerUsername', isEqualTo: username)
        .where('done', isEqualTo: false);

    if (event != null) {
      query = query.where('event', isEqualTo: event);
    }

    final mappedStream = query.snapshots().map(
      (QuerySnapshot snapshot) {
        return snapshot.documents.map(
          (DocumentSnapshot document) {
            return TaskModel.fromFirestore(
              document.data,
              id: document.documentID,
            );
          },
        ).toList();
      },
    );

    return Observable(mappedStream);
  }

  //-----------------------Event related operations-----------------------------

  /// Adds an event to firestore.
  Future<void> addEvent(String userId, EventModel event) async {
    try {
      final dataMap = event.toFirestoreMap();
      await _firestore.collection('users/$userId/events').add(dataMap);
      // After the event was added successfully we have to update the events a
      // user has.
      final user = await getUser(id: userId);
      final newEventsArray = user.events..add(event.name);
      await updateUser(userId, events: newEventsArray);
    } catch (e) {
      print('Error adding Event to firestore: $e');
    }
  }

  /// Returns a Stream of a single event.
  Observable<EventModel> getEventObservable(String userId, String eventId) {
    final mappedStream = _firestore
        .collection('users/$userId/events')
        .document(eventId)
        .snapshots()
        .map(
      (DocumentSnapshot snapshot) {
        return EventModel.fromFirestore(
          snapshot.data,
          id: snapshot.documentID,
        );
      },
    );

    return Observable(mappedStream);
  }

  /// Returns an [EventModel].
  /// Only one out of id or name can be provided, if both are provided id
  /// will have higher priority.
  Future<EventModel> getEvent(String userId,
      {String eventId, String eventName}) async {
    DocumentSnapshot documentSnapshot;
    if (eventId != null) {
      documentSnapshot =
          await _firestore.document('users/$userId/events/$eventId').get();
    } else {
      final querySnapshot = await _firestore
          .collection('users/$userId/events')
          .where('name', isEqualTo: eventName)
          .getDocuments();
      documentSnapshot = querySnapshot.documents.first;
    }
    return EventModel.fromFirestore(
      documentSnapshot.data,
      id: documentSnapshot.documentID,
    );
  }

  /// Deletes an event from firestore.
  ///
  /// It does not delete all the dependent items, this includes tasks and media.
  Future<void> deleteEvent(String userId, String eventId) async {
    try {
      final documentReference =
          _firestore.document('users/$userId/events/$eventId');
      await documentReference.delete();
    } catch (e) {
      print('Error deleting event in firestore: $e');
    }
  }

  /// Updates and event with the provided data.
  ///
  /// At least one of the following has to be provided (otherwise this
  /// operation has no effect): [name], [pendingTasks], [meida], [tasks],
  /// [highPriority], [mediumPriority] or [lowPriority].
  Future<void> updateEvent(
    String userId,
    String eventId, {
    String name,
    int pendingtasks,
    List<String> media,
    List<String> tasks,
    int highPriority,
    int mediumPriority,
    int lowPriority,
  }) async {
    final newData = <String, dynamic>{
      'name': name,
      'pendingtasks': pendingtasks,
      'media': media,
      'tasks': tasks,
      'highPriority': highPriority,
      'mediumPriority': mediumPriority,
      'lowPriority': lowPriority,
    };
    newData.removeWhere((_, value) => value == null);

    // No need to call firestore if there's no new data to update.
    if (newData.isEmpty) {
      return;
    }

    try {
      final documentReference =
          _firestore.document('users/$userId/events/$eventId');
      await documentReference.setData(newData, merge: true);
    } catch (e) {
      print('Error while updating Event in Firestore: $e');
    }
  }

  /// Returns a stream of [List<EventModel] that correspond to
  /// a particular user.
  Observable<List<EventModel>> getUserEvents(String userId) {
    final mappedStream =
        _firestore.collection('users/$userId/events').snapshots().map(
      (QuerySnapshot snapshot) {
        return snapshot.documents.map((DocumentSnapshot documentSnapshot) {
          return EventModel.fromFirestore(
            documentSnapshot.data,
            id: documentSnapshot.documentID,
          );
        }).toList();
      },
    );

    return Observable(mappedStream);
  }
}

final firestoreProvider = FirestoreProvider();
