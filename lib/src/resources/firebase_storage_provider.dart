import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FirebaseStorageProvider {
  final FirebaseStorage _storage;
  final Uuid _uuid;
  // [FirebaseStorage] and [Uuid] instances can be injected for testing purposes.
  // Don't remove.
  FirebaseStorageProvider([FirebaseStorage storage, Uuid uuid])
      : _storage = storage ?? FirebaseStorage.instance,
        _uuid = uuid ?? Uuid();

  /// Uploads a given file to the firebase storage bucket.
  ///
  /// It returns a [StorageUploadTask] which contains the status of the upload.
  /// The [folder] parameters allows the file to be stored at any path in the
  /// bucket.
  StorageUploadTask uploadFile(File file, {String folder}) {}
}
