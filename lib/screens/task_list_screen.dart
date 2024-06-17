import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_form.dart';
import '../widgets/task_item.dart';

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tareas Pendientes'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => TaskForm(),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: taskProvider.pendingTasks.length,
        itemBuilder: (ctx, i) => TaskItem(taskProvider.pendingTasks[i]),
      ),
    );
  }
}
