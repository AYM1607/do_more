import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../models/task_model.dart';
import '../resources/firestore_provider.dart';
import '../services/auth_service.dart';
import '../services/current_task_service.dart';

export '../services/auth_service.dart' show FirebaseUser;

// TODO: Add the text search functionality.

class HomeBloc {
  final AuthService _auth = authService;
  final FirestoreProvider _repository = firestoreProvider;
  final CurrentTaskService _taskService = currentTaskService;
  final _tasks = BehaviorSubject<List<TaskModel>>();

  // Stream getters.
  Observable<List<TaskModel>> get userTasks =>
      _tasks.stream.transform(prioritySortTransformer());

  Observable<FirebaseUser> get userStream => _auth.userStream;

  StreamTransformer<List<TaskModel>, List<TaskModel>>
      prioritySortTransformer() {
    return StreamTransformer.fromHandlers(handleData: (tasksList, sink) {
      tasksList.sort((a, b) => TaskModel.ecodedPriority(b.priority)
          .compareTo(TaskModel.ecodedPriority(a.priority)));
      sink.add(tasksList);
    });
  }

  Future<void> fetchTasks() async {
    final user = await _auth.currentUser;
    _repository.getUserTasks(user.email).pipe(_tasks);
  }

  Future<String> getUserAvatarUrl() async {
    final user = await _auth.currentUser;
    return user.photoUrl;
  }

  Future<String> getUserDisplayName() async {
    final user = await _auth.currentUser;
    return user.displayName;
  }

  void markTaskAsDone(TaskModel task) async {
    _repository.updateTask(
      task.id,
      done: true,
    );
  }

  void updateCurrentTask(TaskModel task) {
    _taskService.setTask(task);
  }

  void dispose() {
    _tasks.close();
  }
}
