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
  final Firestore firestore;

  FirestoreProvider([Firestore firestore])
      : this.firestore = firestore ?? Firestore.instance {
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
  // TODO: Change the Events collection name to 'events' in forestore.

  /// Adds an event to firestore.
  Future<void> addEvent(String userId, EventModel event) async {
    try {
      final dataMap = event.toFirestoreMap();
      await firestore.collection('users/$userId/Events').add(dataMap);
    } catch (e) {
      print('Error adding Event to firestore: $e');
    }
  }

  /// Returns a Stream of a single event.
  Observable<EventModel> getEvent(String userId, String eventId) {
    final mappedStream = firestore
        .collection('users/$userId/Events')
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

  /// Deletes an event from firestore.
  ///
  /// It does not delete all the dependent items, this includes tasks and media.
  Future<void> deleteEvent(String userId, String eventId) async {
    try {
      final documentReference =
          firestore.document('users/$userId/Events/$eventId');
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
    List<int> media,
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
          firestore.document('users/$userId/Events/$eventId');
      await documentReference.setData(newData, merge: true);
    } catch (e) {
      print('Error while updating Event in Firestore: $e');
    }
  }

  /// Returns a stream of [List<EventModel] that correspond to
  /// a particular user.
  Observable<List<EventModel>> getUserEvents(String userDocumentId) {
    final mappedStream =
        firestore.collection('users/$userDocumentId/Events').snapshots().map(
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
