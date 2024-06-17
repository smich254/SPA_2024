import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../screens/edit_task_screen.dart';

class TaskItem extends StatelessWidget {
  final Task task;

  TaskItem(this.task);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.serviceType),
      subtitle: Text(task.clientData),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(task.isDone ? Icons.check_box : Icons.check_box_outline_blank),
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false).toggleTaskStatus(task.id);
            },
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed(
                EditTaskScreen.routeName,
                arguments: task,
              );
            },
          ),
        ],
      ),
    );
  }
}
