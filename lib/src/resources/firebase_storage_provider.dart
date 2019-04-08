import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

export 'package:firebase_storage/firebase_storage.dart'
    show StorageUploadTask, StorageTaskSnapshot;

/// A connection to the firebase sotrage bucket.
class FirebaseStorageProvider {
  /// The reference to the root path of the storage bucket.
  final StorageReference _storage;

  /// An instance of a uuid generator.
  final Uuid _uuid;

  // [FirebaseStorage] and [Uuid] instances can be injected for testing purposes.
  // Don't remove.
  FirebaseStorageProvider([StorageReference storage, Uuid uuid])
      : _storage = storage ?? FirebaseStorage.instance.ref(),
        _uuid = uuid ?? Uuid();

  /// Uploads a given file to the firebase storage bucket.
  ///
  /// It returns a [StorageUploadTask] which contains the status of the upload.
  /// The [type] parameter allows you to specify the extension of the file bein
  /// uploaded, it defaults to png.
  StorageUploadTask uploadFile(File file,
      {String folder = '', String type = 'png'}) {
    folder = folder.startsWith('/') ? folder.substring(1) : folder;
    folder = folder.endsWith('/') ? folder : folder += '/';
    final String fileId = _uuid.v1();
    final StorageReference fileReference =
        _storage.child('$folder$fileId.$type');
    return fileReference.putFile(
      file,
      StorageMetadata(contentType: 'image/png'),
    );
  }

  /// Deletes a file from the firebase storage bucket given its path.
  Future<void> deleteFile(String path) {
    return _storage.child(path).delete();
  }

  // TODO: Add tests for this method.
  // TODO: Delete the tmp file when the app closes.
  /// Returns a future of the file from the path.
  ///
  /// Downloads the raw bytes from the sotrage buckets and converts it to a file.
  Future<File> getFile(String path) async {
    final fileName = path.split('/').last;
    final fileReference = _storage.child(path);
    final metadata = await fileReference.getMetadata();
    final bytes = await fileReference.getData(metadata.sizeBytes);

    final Directory tmp = await getTemporaryDirectory();
    final file = File('${tmp.path}/$fileName');
    return file.writeAsBytes(bytes);
  }
}

final storageProvider = FirebaseStorageProvider();
