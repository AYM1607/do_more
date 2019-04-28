import 'package:rxdart/rxdart.dart';

import '../utils.dart' show kTaskListPriorityTransforemer;
import '../models/task_model.dart';
import '../resources/firestore_provider.dart';
import '../resources/google_sign_in_provider.dart';
import '../services/auth_service.dart';

export '../services/auth_service.dart' show FirebaseUser;

class ArchiveBloc {
  /// An instance of the auth service.
  AuthService _auth = authService;

  /// An instance of the firestore provider.
  FirestoreProvider _firestore = firestoreProvider;

  final _tasks = BehaviorSubject<List<TaskModel>>();

  // Stream getters.
  /// An observable of the current logged in user.
  Observable<FirebaseUser> get userStream => _auth.userStream;

  /// An observable of the done tasks linked to the current user.
  Observable<List<TaskModel>> get tasks =>
      _tasks.stream.transform(kTaskListPriorityTransforemer);

  void fetchTasks() async {
    final userModel = await _auth.getCurrentUserModel();
    _firestore.getUserTasks(userModel.username, done: true).pipe(_tasks);
  }

  void undoTask(TaskModel task) {
    _firestore.updateTask(task.id, done: false);
  }

  dispose() async {
    await _tasks.drain();
    _tasks.close();
  }
}
