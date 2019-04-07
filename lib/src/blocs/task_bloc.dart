import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../utils.dart' show Validators;
import '../models/task_model.dart';
import '../models/user_model.dart';
import '../resources/firestore_provider.dart';
import '../services/auth_service.dart';
import '../services/current_selection_service.dart';

/// Business logic component that manages the state for the task screen.
class TaskBloc extends Object with Validators {
  /// An instance of the auth service.
  final AuthService _auth = authService;

  /// An instance of the firebase repository.
  final FirestoreProvider _firestore = firestoreProvider;

  /// An instance of the current task service.
  final CurrentSelectionService _selectionService = currentSelectionService;

  /// A subject of user model.
  final _user = BehaviorSubject<UserModel>();

  /// A subject of task event name.
  final _eventName = BehaviorSubject<String>();

  /// A subject of task text.
  final _taskText = BehaviorSubject<String>();

  ///  A subject of the text of the current global task.
  final _textInitialValue = BehaviorSubject<String>();

  /// The priority of the current task.
  TaskPriority priority = TaskPriority.high;

  /// The id of the current task.
  ///
  /// Only to be used if editing an existing task.
  String taskId;

  //Stream getters.
  /// An observable of the current user model.
  Observable<UserModel> get userModelStream => _user.stream;

  /// An observable of the current task event name.
  Observable<String> get eventName => _eventName.stream;

  /// An observable of the current task text.
  Observable<String> get taskText =>
      _taskText.stream.transform(validateStringNotEmpty);

  /// An observable of the submit enabled flag.
  Observable<bool> get submitEnabled =>
      Observable.combineLatest2(eventName, taskText, (a, b) => true);

  /// An observable of the text of the global selected task.
  Observable<String> get textInitialvalue => _textInitialValue.stream;

  //Sinks getters.
  /// Changes the current task event name.
  Function(String) get changeEventName => _eventName.sink.add;

  ///Changes the current task text.
  Function(String) get changeTaskText => _taskText.sink.add;

  TaskBloc() {
    setCurrentUser();
  }

  /// Changes the current task priority.
  void setPriority(TaskPriority newPriority) {
    priority = newPriority;
  }

  //TODO: Figure out how to update the event and user properties if needed.
  // as in the number of pending high tasks for example.

  /// Saves or updates the current task in the database.
  Future<void> submit(isEdit) {
    if (isEdit) {
      return _firestore.updateTask(
        taskId,
        text: _taskText.value,
        priority: TaskModel.ecodedPriority(priority),
      );
    }
    final newTask = TaskModel(
      text: _taskText.value,
      priority: priority,
      event: _eventName.value,
      ownerUsername: _user.value.username,
      done: false,
    );
    return _firestore.addTask(newTask);
  }

  /// Fetches and updates the current user.
  Future<void> setCurrentUser() async {
    final user = await _auth.currentUser;
    final userModel = await _firestore.getUser(username: user.email);
    _user.add(userModel);
  }

  /// Grabs the data from the current global task and pipes it to the local
  /// streams.
  void populateWithCurrentTask() {
    // We only want the task that was just selected and stop listening
    // after receiving it.
    _selectionService.task.take(1).listen(
      (TaskModel task) {
        _textInitialValue.sink.add(task.text);
        changeEventName(task.event);
        changeTaskText(task.text);
        taskId = task.id;
      },
    );
  }

  void dispose() {
    _textInitialValue.close();
    _taskText.close();
    _user.close();
    _eventName.close();
  }
}
