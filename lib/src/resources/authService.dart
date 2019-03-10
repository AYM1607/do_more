import 'dart:async';

import 'package:rxdart/rxdart.dart';

import './firestore_provider.dart';
import './google_sign_in_provider.dart';
import '../models/summary_model.dart';
import '../models/user_model.dart';

export './google_sign_in_provider.dart' show FirebaseUser;

class AuthService {
  final GoogleSignInProvider _googleSignInProvider = signInProvider;
  final FirestoreProvider _firestoreProvider = firestoreProvider;
  final _user = BehaviorSubject<FirebaseUser>();

  Observable<FirebaseUser> get userStream => _user.stream;
  Future<FirebaseUser> get currentUser =>
      _googleSignInProvider.getCurrentUser();

  AuthService() {
    _googleSignInProvider.onAuthStateChange.pipe(_user);
  }

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

  void dispose() {
    _user.close();
  }
}

final authService = AuthService();
