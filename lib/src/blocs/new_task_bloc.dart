import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../models/task_model.dart';
import '../models/user_model.dart';
import '../resources/authService.dart';
import '../resources/firestore_provider.dart';

// TODO: Add validation.

class NewTaskBloc {
  final AuthService _auth = authService;
  final FirestoreProvider _firestore = firestoreProvider;
  final _user = BehaviorSubject<UserModel>();
  final _eventName = BehaviorSubject<String>();

  String text = '';
  TaskPriority priority = TaskPriority.high;

  //Stream getters.
  Observable<UserModel> get userModelStream => _user.stream;
  Observable<String> get eventName => _eventName.stream;

  //Sinks getters.
  Function(String) get changeEventName => _eventName.sink.add;

  NewTaskBloc() {
    setCurrentUser();
  }

  void setText(String newText) {
    text = newText;
  }

  void setPriority(TaskPriority newPriority) {
    priority = newPriority;
  }

  Future<void> submit() {
    final newTask = TaskModel(
      text: text,
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
    _user.close();
    _eventName.close();
  }
}
