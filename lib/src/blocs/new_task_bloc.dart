import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../models/task_model.dart';
import '../resources/authService.dart';
import '../resources/firestore_provider.dart';

class NewTaskBloc {
  final AuthService _auth = authService;
  FirebaseUser currentUser;

  String text;
  TaskPriority priority;
  String event;

  NewTaskBloc() {
    setCurrentUser();
  }

  void setText(String newText) {
    text = newText;
  }

  void setPriority(TaskPriority newPriority) {
    priority = newPriority;
  }

  Future<void> setCurrentUser() async {
    final user = await _auth.currentUser;
    currentUser = user;
  }
}
