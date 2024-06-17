import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_item.dart';

class TaskDayScreen extends StatelessWidget {
  static const routeName = '/task-day';

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tareas del Día'),
      ),
      body: ListView.builder(
        itemCount: taskProvider.tasksForToday.length,
        itemBuilder: (ctx, i) => TaskItem(taskProvider.tasksForToday[i]),
      ),
    );
  }
}
