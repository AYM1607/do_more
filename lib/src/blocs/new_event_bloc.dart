import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../utils.dart' show Validators;
import '../models/event_model.dart';
import '../models/user_model.dart';
import '../resources/firestore_provider.dart';
import '../services/auth_service.dart';

/// Business loginc componente that manages the state of the new event screen.
class NewEventBloc extends Object with Validators {
  /// An instance of the auth service.
  final AuthService _auth = authService;

  /// An instance of the firebase repository.
  final FirestoreProvider _firestore = firestoreProvider;

  /// A subject of the name of the event.
  final _eventName = BehaviorSubject<String>();

  /// A subject of the encoded ocurrance of this event.
  final _ocurrance = BehaviorSubject<List<bool>>();

  // Streams getters.
  /// An observable of the name of the event.
  Observable<String> get eventName =>
      _eventName.stream.transform(stringNotEmptyValidator);

  /// An observable of the encoded ocurrance of this event.
  Observable<List<bool>> get ocurrance =>
      _ocurrance.stream.transform(occuranceArrayValidator);

  /// An observable of the submit enabled flag.
  ///
  /// Only emits true when the event occurs at least once a week and the event
  /// name is not empty.
  Observable<bool> get submitEnabled =>
      Observable.combineLatest2(eventName, ocurrance, (a, b) => true);

  //Sinks getters.
  /// Changes the current task event name.
  Function(String) get changeEventName => _eventName.sink.add;

  /// Change the current ocurrance.
  Function(List<bool>) get changeOcurrance => _ocurrance.sink.add;

  //TODO: use a transaction to make the updates in firestore be atomic.
  /// Adds the event to the database.
  Future<void> submit() async {
    final UserModel userModel = await _auth.getCurrentUserModel();
    final event = EventModel(
      when: _ocurrance.value,
      name: _eventName.value,
      pendigTasks: 0,
      mediumPriority: 0,
      highPriority: 0,
      lowPriority: 0,
      media: <String>[],
    );
    await _firestore.updateUser(userModel.id,
        events: <String>[_eventName.value]..addAll(userModel.events));
    return _firestore.addEvent(userModel.id, event);
  }

  dispose() async {
    await _eventName.drain();
    _eventName.close();
    await _ocurrance.drain();
    _ocurrance.close();
  }
}
