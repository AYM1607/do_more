import 'dart:async';

import 'package:do_more/src/resources/google_sign_in_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/mockito.dart';

main() {
  group('GoogleSignInProvider', () {
    test('should return an instance of user', () {
      final googleSignIn = MockGoogleSignIn();
      final auth = MockFirebaseAuth();
      final googleUser = MockGoogleSignInAccount();
      final googleAuth = MockGoogleSignInAuthentication();
      final user = MockFirebaseUser();
      final provider = GoogleSignInProvider(googleSignIn, auth);

      when(googleSignIn.signIn()).thenAnswer((_) => Future.value(googleUser));
      when(googleUser.authentication)
          .thenAnswer((_) => Future.value(googleAuth));
      when(auth.signInWithCredential(any))
          .thenAnswer((_) => Future.value(user));

      expect(provider.signIn(), completion(isInstanceOf<FirebaseUser>()));
    });

    test('should get the current user stored in cache', () {
      final auth = MockFirebaseAuth();
      final user = MockFirebaseUser();
      final provider = GoogleSignInProvider(null, auth);

      when(auth.currentUser()).thenAnswer((_) => Future.value(user));

      expect(
          provider.getCurrentUser(), completion(isInstanceOf<FirebaseUser>()));
    });

    test('should sign out a user', () {
      final auth = MockFirebaseAuth();
      final provider = GoogleSignInProvider(null, auth);

      when(auth.signOut()).thenAnswer((_) => Future.value());

      expect(provider.signOut(), completes);
    });
  });
}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

class MockFirebaseUser extends Mock implements FirebaseUser {}
