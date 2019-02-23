import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import '../models/event_model.dart';
import '../models/user_model.dart';
import '../models/task_model.dart';

/// A connection to the Cloud Firestore database
///
/// Implempents CRUD operations for users, tasks and events.
class FirestoreProvider {
  final Firestore firestore = Firestore.instance;

  FirestoreProvider() {
    firestore.settings(timestampsInSnapshotsEnabled: true);
  }

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

  /// Returns a stream of [List<Task>]
  ///
  /// The [event] parameter is used to query tasks that only are part of a
  /// certain event.
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

  //-----------------------Event related operations-----------------------------

  // TODO: Change the Events collction name to 'events'
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
