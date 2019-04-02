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

  String text = '';
  TaskPriority priority = TaskPriority.high;
  String event = '';

  Observable<UserModel> get userModelStream => _user.stream;

  NewTaskBloc() {
    setCurrentUser();
  }

  void setText(String newText) {
    text = newText;
  }

  void setPriority(TaskPriority newPriority) {
    priority = newPriority;
  }

  void setEvent(String newEvent) {
    event = newEvent;
  }

  Future<void> submit() {
    final newTask = TaskModel(
      text: text,
      priority: priority,
      event: event,
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
}
