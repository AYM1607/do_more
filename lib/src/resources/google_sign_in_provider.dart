import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';

export 'package:firebase_auth/firebase_auth.dart' show FirebaseUser;

/// A Google authentication provider.
///
/// Connects to both Google and Firebase to authenticate a user.
class GoogleSignInProvider {
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _auth;

  // Instances of [GoogleSignIn] and [FirebaseAuth] can be injected for testing
  // purposes. Don't remove.
  GoogleSignInProvider([GoogleSignIn googleSignIn, FirebaseAuth firebaseAuth])
      : _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _auth = firebaseAuth ?? FirebaseAuth.instance;

  /// A stream of [FirebaseUser] that notifies when a user signs in and out.
  Observable<FirebaseUser> get onAuthStateChange =>
      Observable(_auth.onAuthStateChanged);

  /// Returns a future of [FirebaseUser].
  ///
  /// Initiates the Google authentication flow. Returns null if the flow fails
  /// or gets cancelled.
  ///
  /// If the Google account is being used for the first time, a Firebase user
  /// is also created thus this method also works as sign up.
  Future<FirebaseUser> signIn() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user = await _auth.signInWithCredential(credential);
      return user;
    } catch (e) {
      print('Error signing in with Google: $e');
    }
    return null;
  }

  /// Returns a [FirebaseUser] if already signed in, returns null otherwhise.
  Future<FirebaseUser> getCurrentUser() async {
    return await _auth.currentUser();
  }

  /// Signs a user out.
  ///
  /// Deletes the firebase user from disk and disconnects the Google user too.
  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _auth.signOut();
  }
}

final signInProvider = GoogleSignInProvider();
