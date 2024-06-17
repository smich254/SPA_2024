import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => [..._tasks];

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void editTask(String id, Task newTask) {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex >= 0) {
      _tasks[taskIndex] = newTask;
      notifyListeners();
    }
  }

  void toggleTaskStatus(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index].isDone = !_tasks[index].isDone;
      notifyListeners();
    }
  }

  List<Task> get tasksForToday {
    return _tasks.where((task) {
      return DateFormat('yyyy-MM-dd').format(task.serviceDate) ==
          DateFormat('yyyy-MM-dd').format(DateTime.now());
    }).toList();
  }

  List<Task> get pendingTasks => _tasks.where((task) => !task.isDone).toList();

  List<Task> get doneTasks => _tasks.where((task) => task.isDone).toList();
}
