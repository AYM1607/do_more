import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../utils.dart' show Validators;
import '../models/task_model.dart';
import '../models/user_model.dart';
import '../resources/firestore_provider.dart';
import '../services/auth_service.dart';
import '../services/current_task_service.dart';

class TaskBloc extends Object with Validators {
  final AuthService _auth = authService;
  final FirestoreProvider _firestore = firestoreProvider;
  final CurrentTaskService _taskService = currentTaskService;
  final _user = BehaviorSubject<UserModel>();
  final _eventName = BehaviorSubject<String>();
  final _taskText = BehaviorSubject<String>();
  TaskPriority priority = TaskPriority.high;

  String get textInitialValue => _taskService.task.text;

  //Stream getters.
  Observable<UserModel> get userModelStream => _user.stream;
  Observable<String> get eventName => _eventName.stream;
  Observable<String> get taskText =>
      _taskText.stream.transform(validateStringNotEmpty);
  Observable<bool> get submitEnabled =>
      Observable.combineLatest2(eventName, taskText, (a, b) => true);

  //Sinks getters.
  Function(String) get changeEventName => _eventName.sink.add;
  Function(String) get changeTaskText => _taskText.sink.add;

  TaskBloc() {
    setCurrentUser();
  }

  void setPriority(TaskPriority newPriority) {
    priority = newPriority;
  }

  //TODO: Figure out how to update the event and user properties if needed.

  Future<void> submit(isEdit) {
    if (isEdit) {
      return _firestore.updateTask(
        _taskService.task.id,
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

  Future<void> setCurrentUser() async {
    final user = await _auth.currentUser;
    final userModel = await _firestore.getUser(username: user.email);
    _user.add(userModel);
  }

  void populateWithCurrentTask() {
    TaskModel currentTask = _taskService.task;
    if (currentTask != null) {
      changeEventName(currentTask.event);
      changeTaskText(currentTask.text);
    }
  }

  void dispose() {
    _taskText.close();
    _user.close();
    _eventName.close();
  }
}
