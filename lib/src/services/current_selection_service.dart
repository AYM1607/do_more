import '../models/event_model.dart';
import '../models/task_model.dart';

/// A service that keeps track of the current user selection.
///
/// When editing a task or when navigating to an event screen, the new screens
/// can grab the user selection for this service.
class CurrentSelectionService {
  /// The current selected task.
  TaskModel _selectedTask;

  /// The current selected event.
  EventModel _selectedEvent;

  /// The current selected task.
  TaskModel get task => _selectedTask;

  /// The current selected event.
  EventModel get event => _selectedEvent;

  /// Updates the current selected task.
  void updateSelectedTask(TaskModel newTask) {
    _selectedTask = newTask;
  }

  // Updates the current selected event.
  void updateSelectedEvent(EventModel newEvent) {
    _selectedEvent = newEvent;
  }
}

final currentSelectionService = CurrentSelectionService();
