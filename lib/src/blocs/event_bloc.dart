import 'dart:async';

import '../resources/firestore_provider.dart';
import '../resources/firebase_storage_provider.dart';
import '../services/current_selection_service.dart';

/// A business logic component that manages the state for an event screen.
class EventBloc {
  /// An instance of the current selection service.
  final CurrentSelectionService _selectionService = currentSelectionService;

  /// The name of the event that's currently selected.
  ///
  /// Read only.
  String get selectedEventName => _selectionService.event.name;

  /// Fetches the tasks for the current user that a part of the currently
  /// selected event.
  void fetchTasks() {}
  void dispose() {}
}
