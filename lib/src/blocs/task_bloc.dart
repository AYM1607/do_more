import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../utils.dart' show Validators;
import '../models/task_model.dart';
import '../models/user_model.dart';
import '../resources/firestore_provider.dart';
import '../services/auth_service.dart';

/// Business logic component that manages the state for the task screen.
class TaskBloc extends Object with Validators {
  /// An instance of the auth service.
  final AuthService _auth = authService;

  /// An instance of the firebase repository.
  final FirestoreProvider _firestore = firestoreProvider;

  /// A subject of user model.
  ///
  /// Needed to access the username of the owner of the task.
  final _user = BehaviorSubject<UserModel>();

  /// A subject of task event name.
  ///
  /// Only needed if in edit mode. This will receive updates when the task to be
  /// edited is fetched.
  final _eventName = BehaviorSubject<String>();

  /// A subject of task text.
  final _taskText = BehaviorSubject<String>();

  ///  A subject of the text of the current global task.
  ///
  /// Only needed if in edit mode. This will receive updates when the task to be
  /// edited is fetched.
  final _textInitialValue = BehaviorSubject<String>();

  /// The priority of the current task.
  TaskPriority priority = TaskPriority.high;

  /// The id of the current task.
  ///
  /// Only needed if in edit mode. Not needed by the UI.
  final String taskId;

  // Stream getters.
  /// An observable of the current user model.
  Observable<UserModel> get userModelStream => _user.stream;

  /// An observable of the current task event name.
  Observable<String> get eventName => _eventName.stream;

  /// An observable of the current task text.
  ///
  /// Emits an error if the string added is empty.
  Observable<String> get taskText =>
      _taskText.stream.transform(validateStringNotEmpty);

  /// An observable of the submit enabled flag.
  ///
  /// Only emits true when an event is selected and the task text is not empty.
  Observable<bool> get submitEnabled =>
      Observable.combineLatest2(eventName, taskText, (a, b) => true);

  /// An observable of the text of the global selected task.
  ///
  /// Only needed in edit mode.
  Observable<String> get textInitialvalue => _textInitialValue.stream;

  //Sinks getters.
  /// Changes the current task event name.
  Function(String) get changeEventName => _eventName.sink.add;

  ///Changes the current task text.
  Function(String) get changeTaskText => _taskText.sink.add;

  TaskBloc({this.taskId}) {
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
  void populateWithCurrentTask() async {
    final task = await _firestore.getTask(taskId);
    _textInitialValue.sink.add(task.text);
    changeEventName(task.event);
    changeTaskText(task.text);
  }

  void dispose() {
    _textInitialValue.close();
    _taskText.close();
    _user.close();
    _eventName.close();
  }
}
