import 'dart:async';

import 'package:rxdart/rxdart.dart';

import './firestore_provider.dart';
import './google_sign_in_provider.dart';
import '../models/summary_model.dart';
import '../models/user_model.dart';

class AuthService {
  final _user = BehaviorSubject<FirebaseUser>();

  Observable<FirebaseUser> get userStream => _user.stream;

  AuthService() {
    _googleSignInProvider.onAuthStateChange.pipe(_user);
  }

  final _googleSignInProvider = GoogleSignInProvider();
  final _firestoreProvider = FirestoreProvider();

  Future<void> googleLoginAndSignup() async {
    final user = await _googleSignInProvider.signIn();

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
  }

  Future<void> signOut() {
    return _googleSignInProvider.signOut();
  }

  void dispose() {
    _user.close();
  }
}

final authService = AuthService();
