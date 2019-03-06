import 'dart:async';
import 'dart:io';

import 'package:rxdart/rxdart.dart';

import './firebase_storage_provider.dart';
import './firestore_provider.dart';
import './google_sign_in_provider.dart';
import '../models/event_model.dart';
import '../models/task_model.dart';
import '../models/summary_model.dart';
import '../models/user_model.dart';

class Repository {
  final _storageProvider = FirebaseStorageProvider();
  final _firestoreProvider = FirestoreProvider();
  final _googleSignInProvider = GoogleSignInProvider();

  //--------------------------------CRUD----------------------------------------

  Observable<UserModel> getUser(String username) {
    return _firestoreProvider.getUser(username);
  }

  Future<void> updateUser(
    String id, {
    List<String> tasks,
    SummaryModel summary,
    int pendingHigh,
    int pendingMedium,
    int pendingLow,
  }) {
    return _firestoreProvider.updateUser(id,
        tasks: tasks,
        summary: summary,
        pendingHigh: pendingHigh,
        pendingMedium: pendingMedium,
        pendingLow: pendingLow);
  }

  Future<void> addTask(TaskModel task) {
    return _firestoreProvider.addTask(task);
  }

  Future<void> deleteTask(String id) {
    return _firestoreProvider.deleteTask(id);
  }

  Observable<TaskModel> getTask(String id) {
    return _firestoreProvider.getTask(id);
  }

  Future<void> updateTask(
    String id, {
    String text,
    int priority,
    bool done,
  }) {
    return _firestoreProvider.updateTask(id,
        text: text, priority: priority, done: done);
  }

  Observable<List<TaskModel>> getUserTasks(String username, {String event}) {
    return _firestoreProvider.getUserTasks(username, event: event);
  }

  Future<void> addEvent(String userId, EventModel event) {
    return _firestoreProvider.addEvent(userId, event);
  }

  Future<void> deleteEvent(String userId, String eventId) {
    return _firestoreProvider.deleteEvent(userId, eventId);
  }

  Observable<EventModel> getEvent(String userId, String eventId) {
    return _firestoreProvider.getEvent(userId, eventId);
  }

  Future<void> updateEvent(
    String userId,
    String eventId, {
    String name,
    int pendingtasks,
    List<int> media,
    List<String> tasks,
    int highPriority,
    int mediumPriority,
    int lowPriority,
  }) {
    return _firestoreProvider.updateEvent(
      userId,
      eventId,
      name: name,
      pendingtasks: pendingtasks,
      media: media,
      tasks: tasks,
      highPriority: highPriority,
      mediumPriority: mediumPriority,
      lowPriority: lowPriority,
    );
  }

  Observable<List<EventModel>> getUserEvents(String userId) {
    return _firestoreProvider.getUserEvents(userId);
  }

  //-----------------------------------AUTH-------------------------------------

  Future<FirebaseUser> googleLoginAndSignup() async {
    final user = await _googleSignInProvider.signIn();
    if (user == null) {
      return null;
    }
    // Create a new user in Firestore if this is the first time signing in.
    if (!await _firestoreProvider.userExists(user.email)) {
      final newUserModel = UserModel(
        username: user.email,
        tasks: <String>[],
        summary: SummaryModel(),
        pendingHigh: 0,
        pendingMedium: 0,
        pendingLow: 0,
      );
      await _firestoreProvider.createUser(newUserModel, user.uid);
    }
    return user;
  }

  Future<void> signOut() {
    return _googleSignInProvider.signOut();
  }

  //---------------------------------STORAGE------------------------------------

  StorageUploadTask uploadFile(File file,
      {String folder = '', String type = 'png'}) {
    return _storageProvider.uploadFile(file, folder: folder, type: type);
  }

  Future<void> deleteFile(String path) {
    return _storageProvider.deleteFile(path);
  }
}
