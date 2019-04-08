import 'dart:async';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../models/event_model.dart';
import '../models/task_model.dart';
import '../models/user_model.dart';
import '../resources/firestore_provider.dart';
import '../resources/firebase_storage_provider.dart';
import '../services/auth_service.dart';
import '../utils.dart'
    show kTaskListPriorityTransforemer, getImageThumbnailPath;

/// A business logic component that manages the state for an event screen.
class EventBloc {
  /// The name of the event being shown.
  final String eventName;

  /// An instance of a firestore provider.
  final FirestoreProvider _firestore = firestoreProvider;

  /// An instance of the firebase sotrage provider.
  final FirebaseStorageProvider _storage = storageProvider;

  /// An instace of the auth service.
  final AuthService _auth = authService;

  /// A subject of list of task model.
  final _tasks = BehaviorSubject<List<TaskModel>>();

  /// A subject of the list of image paths for this event.
  final _imagesPaths = BehaviorSubject<List<String>>();

  /// A subject of String paths.
  final _imagesFetcher = PublishSubject<String>();

  /// A subject of String paths.
  final _imagesThumbnailsFetcher = PublishSubject<String>();

  /// A subject of a cache that contains the image files.
  final _thumbnails = BehaviorSubject<Map<String, Future<File>>>();

  /// A subject of a cache that contains the image files.
  final _images = BehaviorSubject<Map<String, Future<File>>>();

  /// The event being managed by this bloc.
  EventModel _event;

  /// The representation of the current signed in user.
  UserModel _user;

  /// Whether the event and user models have been fetched;
  Future<void> _ready;
  // Stream getters.
  /// An observable of the tasks linked to the event.
  Observable<List<TaskModel>> get eventTasks =>
      _tasks.stream.transform(kTaskListPriorityTransforemer);

  /// An observable of the list of paths of images linked to this event.
  Observable<List<String>> get imagesPaths => _imagesPaths.stream;

  /// An observable of a cache of the images thumbnails files.
  Observable<Map<String, Future<File>>> get thumbnails => _thumbnails.stream;

  /// An observable of a cache of the images files.
  Observable<Map<String, Future<File>>> get images => _images.stream;

  // Sinks getters.
  /// Starts the fetching process for an image given its path.
  Function(String) get fetchImage => _imagesFetcher.sink.add;

  /// Starts the fetching process for an image thumbail given its path.
  Function(String) get fetchThumbnail => _imagesThumbnailsFetcher.sink.add;

  EventBloc({
    @required this.eventName,
  }) {
    _ready = _initUserAndEvent();
    _imagesFetcher.transform(_imagesTransformer()).pipe(_images);
    _imagesThumbnailsFetcher
        .transform(_imagesTransformer(isThumbnail: true))
        .pipe(_thumbnails);
  }

  /// Initializes the value for the User and the Event models.
  Future<void> _initUserAndEvent() async {
    final userModelFuture = _auth.getCurrentUserModel();
    _user = await userModelFuture;
    _event = await _firestore.getEvent(
      (await userModelFuture).id,
      eventName: eventName,
    );
  }

  /// Returns a stream transformer that creates a cache map from image storage
  /// bucket paths.
  ScanStreamTransformer<String, Map<String, Future<File>>> _imagesTransformer({
    bool isThumbnail = false,
  }) {
    final accumulator = (Map<String, Future<File>> cache, String path, _) {
      if (isThumbnail) {
        path = getImageThumbnailPath(path);
      }
      if (cache.containsKey(path)) {
        return cache;
      }
      cache[path] = _storage.getFile(path);
      return cache;
    };

    return ScanStreamTransformer(accumulator, <String, Future<File>>{});
  }

  /// Fetches the tasks for the current user that a part of the currently
  /// selected event.
  Future<void> fetchTasks() async {
    await _ready;
    _firestore.getUserTasks(_user.username, event: eventName).pipe(_tasks);
  }

  /// Fetches the paths of all the images linked to this event.
  Future<void> fetchImagesPaths() async {
    await _ready;
    _imagesPaths.sink.add(_event.media);
  }

  /// Marks a task as done in the database.
  void markTaskAsDone(TaskModel task) async {
    _firestore.updateTask(
      task.id,
      done: true,
    );
  }

  void dispose() async {
    await _imagesThumbnailsFetcher.drain();
    _imagesThumbnailsFetcher.close();
    await _imagesFetcher.drain();
    _imagesFetcher.close();
    await _thumbnails.drain();
    _thumbnails.close();
    await _images.drain();
    _images.close();
    await _imagesPaths.drain();
    _imagesPaths.close();
    await _tasks.drain();
    _tasks.close();
  }
}
