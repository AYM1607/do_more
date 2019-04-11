import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../utils.dart' show kTaskListPriorityTransforemer;
import '../models/task_model.dart';
import '../resources/firestore_provider.dart';
import '../services/auth_service.dart';

export '../services/auth_service.dart' show FirebaseUser;

/// A business logic component that manages the state of the home screen.
class HomeBloc {
  /// An instance of the auth service.
  final AuthService _auth = authService;

  /// An instance of the firebase repository.
  final FirestoreProvider _firestore = firestoreProvider;

  /// A subject of list of task model.
  final _tasks = BehaviorSubject<List<TaskModel>>();

  /// A subject of the search box updates.
  final _searchBoxText = BehaviorSubject<String>(seedValue: '');

  // Stream getters.

  // The result has to be a combination of the tasks stream and the text
  // stream, because otherwise, the tasks stream has no way of knowing when
  // there's a new update in the text.
  //
  // The transformations have to be applied after the combination,
  // otherwhise the value used for filtering is outdated and the list output is
  // not synchronized with the current value of the searhc box text.
  /// An observalbe of the taks of a user.
  Observable<List<TaskModel>> get userTasks =>
      Observable.combineLatest2<String, List<TaskModel>, List<TaskModel>>(
        _searchBoxText.stream,
        _tasks.stream,
        (text, tasks) {
          return tasks;
        },
      )
          .transform(_searchBoxTransformer())
          .transform(kTaskListPriorityTransforemer);

  /// An observable of the current logged in user.
  Observable<FirebaseUser> get userStream => _auth.userStream;

  // TODO: Include the priority in the filtering.
  /// Returns a stream transformer that filters the task with the text from
  /// the search box.
  StreamTransformer<List<TaskModel>, List<TaskModel>> _searchBoxTransformer() {
    return StreamTransformer.fromHandlers(
      handleData: (taskList, sink) {
        sink.add(
          taskList.where(
            (TaskModel task) {
              if (_searchBoxText.value == '') {
                return true;
              }
              // Return true if the text in the search box matches the title
              // or the text of the task.
              return task.event
                      .toLowerCase()
                      .contains(_searchBoxText.value.toLowerCase()) ||
                  task.text
                      .toLowerCase()
                      .contains(_searchBoxText.value.toLowerCase());
            },
          ).toList(),
        );
      },
    );
  }

  /// Fetches the tasks for the current user.
  Future<void> fetchTasks() async {
    final user = await _auth.currentUser;
    _firestore.getUserTasks(user.email).pipe(_tasks);
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
    _firestore.updateTask(
      task.id,
      done: true,
    );
  }

  /// Updates the serach box text.
  void updateSearchBoxText(String newText) {
    _searchBoxText.add(newText);
  }

  void dispose() async {
    await _searchBoxText.drain();
    _searchBoxText.close();
    await _tasks.drain();
    _tasks.close();
  }
}
