import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../models/task_model.dart';
import '../resources/firestore_provider.dart';
import '../services/auth_service.dart';
import '../services/current_task_service.dart';

export '../services/auth_service.dart' show FirebaseUser;

// TODO: Add the text search functionality.

/// A business logic component that manages the state of the home screen.
class HomeBloc {
  /// An instance of the auth service.
  final AuthService _auth = authService;

  /// An instance of the firebase repository.
  final FirestoreProvider _repository = firestoreProvider;

  /// An instance of the current task service.
  final CurrentTaskService _taskService = currentTaskService;

  /// A subject of list of task model.
  final _tasks = BehaviorSubject<List<TaskModel>>();

  // Stream getters.
  /// An observalbe of the taks of a user.
  Observable<List<TaskModel>> get userTasks =>
      _tasks.stream.transform(prioritySortTransformer());

  /// An observable of the current logged in user.
  Observable<FirebaseUser> get userStream => _auth.userStream;

  /// Returns a stream transformer that sorts the tasks by priority.
  StreamTransformer<List<TaskModel>, List<TaskModel>>
      prioritySortTransformer() {
    return StreamTransformer.fromHandlers(handleData: (tasksList, sink) {
      tasksList.sort((a, b) => TaskModel.ecodedPriority(b.priority)
          .compareTo(TaskModel.ecodedPriority(a.priority)));
      sink.add(tasksList);
    });
  }

  /// Fetches the tasks for the current user.
  Future<void> fetchTasks() async {
    final user = await _auth.currentUser;
    _repository.getUserTasks(user.email).pipe(_tasks);
  }

  /// Returns a future of the avatar url for the current user.
  Future<String> getUserAvatarUrl() async {
    final user = await _auth.currentUser;
    return user.photoUrl;
  }

  /// Returns a future of the display name for the current user.
  Future<String> getUserDisplayName() async {
    final user = await _auth.currentUser;
    return user.displayName;
  }

  /// Marks a task as done in the database.
  void markTaskAsDone(TaskModel task) async {
    _repository.updateTask(
      task.id,
      done: true,
    );
  }

  /// Sets the global current task.
  void updateCurrentTask(TaskModel task) {
    _taskService.setTask(task);
  }

  void dispose() {
    _tasks.close();
  }
}
