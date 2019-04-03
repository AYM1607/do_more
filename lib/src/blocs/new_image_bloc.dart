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
  final FirebaseStorageProvider _storage = storageProvider;
  final _picture = BehaviorSubject<File>();
  final _user = BehaviorSubject<UserModel>();

  String eventName;

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

  void setEvent(String newEventName) {
    eventName = newEventName;
  }

  Future<void> submit() async {
    final user = _user.value;
    final StorageUploadTask uploadTask =
        _storage.uploadFile(_picture.value, folder: '${user.id}/');
    final storageSnapshot = await uploadTask.onComplete;
    final imagePath = storageSnapshot.ref.path;
    EventModel event = await _firestore.getEvent(user.id, eventName: eventName);
    final newMediaList = List<String>.from(event.media)..add(imagePath);
    await _firestore.updateEvent(user.id, event.id, media: newMediaList);
  }

  void dispose() {
    _picture.close();
  }
}
