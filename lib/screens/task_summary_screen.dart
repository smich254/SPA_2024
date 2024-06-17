import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class TaskSummaryScreen extends StatelessWidget {
  static const routeName = '/task-summary';

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Resumen de Tareas'),
      ),
      body: ListView.builder(
        itemCount: taskProvider.doneTasks.length,
        itemBuilder: (ctx, i) => ListTile(
          title: Text(taskProvider.doneTasks[i].serviceType),
          subtitle: Text(taskProvider.doneTasks[i].clientData),
          trailing: Text('\$${taskProvider.doneTasks[i].amount.toStringAsFixed(2)}'),
        ),
      ),
    );
  }
}
