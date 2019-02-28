import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
export 'package:firebase_storage/firebase_storage.dart' show StorageUploadTask;

class FirebaseStorageProvider {
  final StorageReference _storage;
  final Uuid _uuid;
  // [FirebaseStorage] and [Uuid] instances can be injected for testing purposes.
  // Don't remove.
  FirebaseStorageProvider([StorageReference storage, Uuid uuid])
      : _storage = storage ?? FirebaseStorage.instance.ref(),
        _uuid = uuid ?? Uuid();

  /// Uploads a given file to the firebase storage bucket.
  ///
  /// It returns a [StorageUploadTask] which contains the status of the upload.
  /// The [folder] parameter should not start with "/" , it allows the file to
  /// be stored at any path in the bucket.
  /// The [type] parameter allows you to specify the extension of the file bein
  /// uploaded, it defaults to png.
  StorageUploadTask uploadFile(File file,
      {String folder, String type = 'png'}) {
    final String fileId = _uuid.v1();
    final StorageReference fileReference =
        _storage.child('folder/$fileId.$type');
    return fileReference.putFile(file);
  }
}
