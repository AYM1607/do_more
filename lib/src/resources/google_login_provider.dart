<<<<<<< HEAD
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider {
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _auth;

  GoogleSignInProvider([GoogleSignIn googleSignIn, FirebaseAuth firebaseAuth])
      : _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _auth = firebaseAuth ?? FirebaseAuth.instance;

  Future<FirebaseUser> signIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    print("signed in " + user.displayName);
    return user;
  }
}
=======
import 'package:firebase_auth/firebase_auth.dart';
>>>>>>> Added necessary dependencies for google sing in, created the google_sign_in provider, modified Info.plist to work with google sign in
