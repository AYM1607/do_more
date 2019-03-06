import 'package:rxdart/rxdart.dart';

import './firebase_storage_provider.dart';
import './firestore_provider.dart';
import './google_sign_in_provider.dart';
import '../models/event_model.dart';
import '../models/task_model.dart';
import '../models/user_model.dart';

class Repository {
  final _storageProvider = FirebaseStorageProvider();
  final _firestoreProvider = FirestoreProvider();
  final _googleSignInProvider = GoogleSignInProvider();

  Observable<UserModel> getUser(String username) {
    return _firestoreProvider.getUser(username);
  }

  Future<void> createUser(UserModel user) {}
}
