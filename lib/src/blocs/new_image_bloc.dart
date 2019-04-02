import 'dart:async';
import 'dart:io';

import 'package:rxdart/rxdart.dart';

import '../models/task_model.dart';
import '../models/user_model.dart';
import '../resources/authService.dart';
import '../resources/firestore_provider.dart';

class NewImageBloc {
  final _picture = BehaviorSubject<File>();

  //Stream getters.
  Observable<File> get picture => _picture.stream;

  //Sink getters.
  Function(File) get addPicture => _picture.sink.add;

  void dispose() {
    _picture.close();
  }
}
