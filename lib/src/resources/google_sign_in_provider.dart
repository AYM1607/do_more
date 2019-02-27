import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';

class GoogleSignInProvider {
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _auth;

  GoogleSignInProvider([GoogleSignIn googleSignIn, FirebaseAuth firebaseAuth])
      : _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _auth = firebaseAuth ?? FirebaseAuth.instance;

  Observable<FirebaseUser> get onAuthStateChange =>
      Observable(_auth.onAuthStateChanged);

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

  Future<FirebaseUser> getCurrentUser() async {
    return await _auth.currentUser();
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _auth.signOut();
  }
}
