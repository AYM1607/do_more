import 'dart:async';
import 'dart:io';

import 'package:rxdart/rxdart.dart';

import '../models/event_model.dart';
import '../models/user_model.dart';
import '../resources/authService.dart';
import '../resources/firebase_storage_provider.dart';
import '../resources/firestore_provider.dart';

// TODO: Add validation

class NewImageBloc {
  final AuthService _auth = authService;
  final FirestoreProvider _firestore = firestoreProvider;
  final _picture = BehaviorSubject<File>();
  final _user = BehaviorSubject<UserModel>();

  String event;

  NewImageBloc() {
    setCurrentUser();
  }

  //Stream getters.
  Observable<File> get picture => _picture.stream;
  Observable<UserModel> get userModelStream => _user.stream;

  //Sink getters.
  Function(File) get addPicture => _picture.sink.add;

  Future<void> setCurrentUser() async {
    final user = await _auth.currentUser;
    final userModel = await _firestore.getUser(username: user.email);
    _user.add(userModel);
  }

  void setEvent(String newEvent) {
    event = newEvent;
  }

  Future<void> submit() {
    List<String> events = _user.value.events;
  }

  void dispose() {
    _picture.close();
  }
}
