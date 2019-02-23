import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import '../models/event_model.dart';
import '../models/user_model.dart';
import '../models/task_model.dart';

/**
* TODO: the cloud firestore plugin currently throws an error when calling
* methods that modify documents. Wait for a fix.
* https://github.com/flutter/flutter/issues/28103
*/

/// A connection to the Cloud Firestore database
///
/// Implempents CRUD operations for users, tasks and events.
class FirestoreProvider {
  final Firestore firestore = Firestore.instance;

  FirestoreProvider() {
    firestore.settings(timestampsInSnapshotsEnabled: true);
  }
  //-----------------------User related operations------------------------------

  /// Returns a stream of [UserModel].
  Observable<UserModel> getUser(String username) {
    final mappedStream = firestore
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

  //-------------------------Task related operations----------------------------

  /// Adds a task to firestore.
  Future<void> addTask(TaskModel task) async {
    try {
      final dataMap = task.toFirestoreMap();
      await firestore.collection('tasks').add(dataMap);
    } catch (e) {
      print('Error adding task to firestore: $e');
    }
  }

  /// Returns a Stream of a single task from an id.
  Observable<TaskModel> getTask(String id) {
    final mappedStream =
        firestore.collection('tasks').document(id).snapshots().map(
      (DocumentSnapshot snapshot) {
        return TaskModel.fromFirestore(
          snapshot.data,
          id: snapshot.documentID,
        );
      },
    );

    return Observable(mappedStream);
  }

  /// Deletes a task from firestore.
  Future<void> deleteTask(String id) async {
    try {
      final documentReference = firestore.collection('tasks').document(id);
      await documentReference.delete();
    } catch (e) {
      print('Error deleting task from firestore: $e');
    }
  }

  /// Updates a task in firestore.
  ///
  /// Only the [text], [priority] and [done] attributes can be update.
  /// Provide at least one of these values.
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
    try {
      final documentReference = firestore.collection('tasks').document(id);
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
    Query query = firestore
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

  // TODO: Change the Events collction name to 'events' in forestore.
  Observable<List<EventModel>> getUserEvents(String userDocumentId) {
    final mappedStream = firestore
        .collection('users')
        .document(userDocumentId)
        .collection('Events')
        .snapshots()
        .map(
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
