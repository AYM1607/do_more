import 'dart:async';
import 'package:meta/meta.dart';

import '../resources/firestore_provider.dart';
import '../resources/firebase_storage_provider.dart';

/// A business logic component that manages the state for an event screen.
class EventBloc {
  /// The name of the event being shown.
  final String eventName;
  EventBloc({
    @required this.eventName,
  });

  /// Fetches the tasks for the current user that a part of the currently
  /// selected event.
  void fetchTasks() {}
  void dispose() {}
}
