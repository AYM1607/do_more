import '../models/task_model.dart';

class CurrentTaskService {
  TaskModel _currentTask;

  TaskModel get task => _currentTask;

  void setTask(TaskModel newTask) {
    _currentTask = newTask;
  }
}

final currentTaskService = CurrentTaskService();
