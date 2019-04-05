import 'dart:async';
import 'dart:io';

import 'package:rxdart/rxdart.dart';

import '../models/event_model.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../resources/firebase_storage_provider.dart';
import '../resources/firestore_provider.dart';

/// A business logic component that manages the state for the new image screen.
class NewImageBloc {
  /// An instance of the auth service.
  final AuthService _auth = authService;

  /// An instance of the firestore provider.
  final FirestoreProvider _firestore = firestoreProvider;

  /// An instance of the firebase storage provider.
  final FirebaseStorageProvider _storage = storageProvider;

  /// A subject of the current picture file.
  final _picture = BehaviorSubject<File>();

  /// A subject of the current user model.
  final _user = BehaviorSubject<UserModel>();

  /// A subject of the current task event name.
  final _eventName = BehaviorSubject<String>();

  NewImageBloc() {
    setCurrentUser();
  }

  //Stream getters.
  /// An observable of the picture file.
  Observable<File> get picture => _picture.stream;

  /// An observable of the user model.
  Observable<UserModel> get userModelStream => _user.stream;

  /// An observable of the task event name.
  Observable<String> get eventName => _eventName.stream;

  /// An observable of the ready to submit flag.
  Observable<bool> get submitEnabled =>
      Observable.combineLatest2(_picture, _eventName, (a, b) => true);

  //Sink getters.
  /// Changes the current picture file.
  Function(File) get changePicture => _picture.sink.add;

  /// Changes the current task event name.
  Function(String) get changeEventName => _eventName.sink.add;

  /// Fetches and updates the current user.
  Future<void> setCurrentUser() async {
    final user = await _auth.currentUser;
    final userModel = await _firestore.getUser(username: user.email);
    _user.add(userModel);
  }

  /// Saves the current picture to the database.
  Future<void> submit() async {
    final user = _user.value;
    final StorageUploadTask uploadTask =
        _storage.uploadFile(_picture.value, folder: '${user.id}/');
    final storageSnapshot = await uploadTask.onComplete;
    final imagePath = storageSnapshot.ref.path;
    EventModel event =
        await _firestore.getEvent(user.id, eventName: _eventName.value);
    final newMediaList = List<String>.from(event.media)..add(imagePath);
    await _firestore.updateEvent(user.id, event.id, media: newMediaList);
  }

  void dispose() {
    _eventName.close();
    _picture.close();
  }
}
