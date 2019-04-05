import '../models/task_model.dart';

/// A service that keeps track of the current selected task.
class CurrentTaskService {
  /// The current selected task.
  TaskModel _currentTask;

  /// The current selected task.
  TaskModel get task => _currentTask;

  /// Sets the current selected task.
  void setTask(TaskModel newTask) {
    _currentTask = newTask;
  }
}

final currentTaskService = CurrentTaskService();
