import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../models/task_model.dart';
import '../resources/firestore_provider.dart';
import '../resources/firebase_storage_provider.dart';
import '../services/auth_service.dart';
import '../utils.dart' show kTaskListPriorityTransforemer;

/// A business logic component that manages the state for an event screen.
class EventBloc {
  /// The name of the event being shown.
  final String eventName;

  /// An instance of a firestore provider.
  final FirestoreProvider _firestore = firestoreProvider;

  /// An instace of the auth service.
  final AuthService _auth = authService;

  /// A subject of list of task model.
  final _tasks = BehaviorSubject<List<TaskModel>>();

  // Stream getters.
  /// An observable of the tasks linked to the event.
  Observable<List<TaskModel>> get eventTasks =>
      _tasks.stream.transform(kTaskListPriorityTransforemer);

  EventBloc({
    @required this.eventName,
  });

  /// Fetches the tasks for the current user that a part of the currently
  /// selected event.
  Future<void> fetchTasks() async {
    final user = await _auth.currentUser;
    _firestore.getUserTasks(user.email, event: eventName).pipe(_tasks);
  }

  /// Marks a task as done in the database.
  void markTaskAsDone(TaskModel task) async {
    _firestore.updateTask(
      task.id,
      done: true,
    );
  }

  void dispose() async {
    await _tasks.drain();
    _tasks.close();
  }
}
