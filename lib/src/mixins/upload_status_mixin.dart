import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../utils.dart';
import '../services/upload_status_service.dart';

mixin UploadStatusMixin {
  /// An instance of the upload status service.
  final UploadStatusService uploadStatusSer = uploadStatusService;

  /// A subject of a flag that indicates if there is a snack bar showing.
  final snackBarStatusSubject = BehaviorSubject<bool>(seedValue: false);

  /// An observable of a flag that indicates whether or not a snackBar is
  /// currently showing.
  ValueObservable<bool> get snackBarStatus => snackBarStatusSubject.stream;

  /// Updates the snack bar status.
  Function(bool) get updateSnackBarStatus => snackBarStatusSubject.sink.add;

  /// An observable of the status of files being uploaded.
  Observable<UploadStatus> get uploadStatus => uploadStatusSer.status;

  /// Disposes instance variables that are part of the mixin.
  Future<void> disposeUploadStatusMixin() async {
    await snackBarStatusSubject.drain();
    snackBarStatusSubject.close();
  }

  /// Initializes the [snacBarStatusSubject].
  ///
  /// The raw status coming from the [UploadStatusService] is transformed and
  /// turned into a stream that emits [true] when the snackbar should be visible
  /// and false otherwise. This is piped to [the snackBarStatusSubject].
  void initializeSnackBarStatus() {
    uploadStatusService.status
        .transform(StreamTransformer<UploadStatus, bool>.fromHandlers(
          handleData: (value, sink) {
            sink.add(value.numberOfFiles != 0);
          },
        ))
        .transform(DistinctStreamTransformer())
        .pipe(snackBarStatusSubject);
  }
}
