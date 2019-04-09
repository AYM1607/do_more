import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

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
  // TODO: Add support for requests taking too long not only errors.
  /// Returns a future of the file from the path.
  ///
  /// Downloads the raw bytes from the sotrage buckets and converts it to a file.
  /// The fetching process is repeated up to [retries] times with a [retryDelay]
  /// delay in between tries.
  Future<File> getFile(
    String path, {
    int retries = 3,
    Duration retryDelay = const Duration(seconds: 2),
  }) async {
    final Directory tmp = await getTemporaryDirectory();
    final fileName = path.split('/').last;
    final file = File('${tmp.path}/$fileName');

    // Don't re-fetch if the file is already in the temp directory.
    if (await file.exists()) {
      return file;
    }
    Uint8List bytes;
    // Repeat until the fetching process is successful or the number of retries
    // is excceded.
    while (bytes == null && retries > 0) {
      final fileReference = _storage.child(path);
      // Assing null to metadata if there's an error during the fetching process.
      // aka the file potentially doesn't exist.
      final metadata =
          await fileReference.getMetadata().catchError((error) => null);
      // Restart the fetching process if there was an error.
      if (metadata == null) {
        print('retrying');
        await Future.delayed(retryDelay);
        retries -= 1;
        continue;
      }
      bytes = await fileReference.getData(metadata.sizeBytes);
      print('done getting data');
    }
    if (bytes == null) {
      return null;
    }
    return file.writeAsBytes(bytes);
  }
}

final storageProvider = FirebaseStorageProvider();
