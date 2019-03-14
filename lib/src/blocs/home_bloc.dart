import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../models/task_model.dart';
import '../resources/authService.dart';
import '../resources/firestore_provider.dart';

class HomeBloc {
  final AuthService _auth = authService;
  final FirestoreProvider _firestore = firestoreProvider;
  final _tasks = BehaviorSubject<List<TaskModel>>();

  // Stream getters.
  Observable<List<TaskModel>> get userTasks => _tasks.stream;

  Future<void> fetchTasks() async {
    final user = await _auth.currentUser;
    _firestore.getUserTasks(user.email).pipe(_tasks);
  }

  void markTaskAsDone(TaskModel task) async {
    _firestore.updateTask(
      task.id,
      done: true,
    );
  }

  void dispose() {
    _tasks.close();
  }
}
