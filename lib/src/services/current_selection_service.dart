import 'package:rxdart/rxdart.dart';

import '../models/event_model.dart';
import '../models/task_model.dart';

/// A service that keeps track of the current user selection.
///
/// When editing a task or when navigating to an event screen, the new screens
/// can grab the user selection for this service.
class CurrentSelectionService {
  /// The current selected task.
  final _selectedTask = BehaviorSubject<TaskModel>();

  /// The current selected event.
  final _selectedEvent = BehaviorSubject<EventModel>();

  /// An observable of the current selected event.
  Observable<TaskModel> get task => _selectedTask.stream;

  /// The current selected event.
  Observable<EventModel> get event => _selectedEvent.stream;

  /// Updates the current selected task.
  Function(TaskModel) get updateSelectedTask => _selectedTask.sink.add;

  // Updates the current selected event.
  Function(EventModel) get updateSelectedEvent => _selectedEvent.sink.add;

  dispose() {
    _selectedEvent.close();
    _selectedTask.close();
  }
}

final currentSelectionService = CurrentSelectionService();
