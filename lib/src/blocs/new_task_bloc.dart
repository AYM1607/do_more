import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../utils.dart' show Validators;
import '../models/task_model.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../resources/firestore_provider.dart';

class NewTaskBloc extends Object with Validators {
  final AuthService _auth = authService;
  final FirestoreProvider _firestore = firestoreProvider;
  final _user = BehaviorSubject<UserModel>();
  final _eventName = BehaviorSubject<String>();
  final _taskText = BehaviorSubject<String>();

  TaskPriority priority = TaskPriority.high;

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

  NewTaskBloc() {
    setCurrentUser();
  }

  void setPriority(TaskPriority newPriority) {
    priority = newPriority;
  }

  Future<void> submit() {
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

  void dispose() {
    _taskText.close();
    _user.close();
    _eventName.close();
  }
}
