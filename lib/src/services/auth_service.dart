import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../resources/firestore_provider.dart';
import '../resources/google_sign_in_provider.dart';
import '../models/summary_model.dart';
import '../models/user_model.dart';

export '../resources/google_sign_in_provider.dart' show FirebaseUser;

class AuthService {
  /// An instance of [GoogleSignInProvider].
  final GoogleSignInProvider _googleSignInProvider = signInProvider;

  /// An instance of the firestore provider.
  final FirestoreProvider _firestoreProvider = firestoreProvider;

  /// A subject of Firebase user.
  final _user = BehaviorSubject<FirebaseUser>();

  // Stream getters.
  /// An observable of the current [FirebaseUser]
  Observable<FirebaseUser> get userStream => _user.stream;

  /// A future of the current [FirebaseUser].
  Future<FirebaseUser> get currentUser =>
      _googleSignInProvider.getCurrentUser();

  AuthService() {
    _googleSignInProvider.onAuthStateChange.pipe(_user);
  }

  /// Logs in or Signs up a user.
  ///
  /// Checks if the account used to sign up is already registered, log the user
  /// in if it is, create a new user otherwise.
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
        events: <String>[],
        summary: SummaryModel(),
        pendingHigh: 0,
        pendingMedium: 0,
        pendingLow: 0,
      );
      await _firestoreProvider.createUser(newUserModel, user.uid);
    }

    return user;
  }

  /// Sings out the current user.
  Future<void> signOut() {
    return _googleSignInProvider.signOut();
  }

  /// Returns the model that represents the current logged in user.
  Future<UserModel> getCurrentUserModel() async {
    final user = await _googleSignInProvider.getCurrentUser();
    if (user != null) {
      return _firestoreProvider.getUser(username: user.email);
    }
    return null;
  }

  void dispose() {
    _user.close();
  }
}

final authService = AuthService();
