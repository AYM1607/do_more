import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../models/event_model.dart';
import '../resources/firestore_provider.dart';
import '../resources/google_sign_in_provider.dart';
import '../services/auth_service.dart';

export '../services/auth_service.dart' show FirebaseUser;

class EventsBloc {
  /// An instance of the auth service.
  AuthService _auth = authService;

  /// An instance of the firestore provider.
  FirestoreProvider _firestore = firestoreProvider;

  /// A subject of list of event model.
  final _events = BehaviorSubject<List<EventModel>>();

  /// An observable of the current logged in user.
  Observable<FirebaseUser> get userStream => _auth.userStream;

  /// Initiates the fetching process of events linked to the current user.
  Future<void> fetchEvents() async {
    final userModel = await _auth.getCurrentUserModel();
    _firestore.getUserEvents(userModel.id).pipe(_events);
  }

  dispose() async {
    await _events.drain();
    _events.close();
  }
}
