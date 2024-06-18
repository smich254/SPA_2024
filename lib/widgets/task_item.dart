import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../screens/edit_task_screen.dart';
import '../widgets/task_preview_dialog.dart';

class TaskItem extends StatelessWidget {
  final Task task;

  TaskItem(this.task);

  Color _getTaskColor(DateTime serviceDate) {
    final now = DateTime.now();
    final difference = serviceDate.difference(now);

    if (difference.inMinutes <= 10 && difference.inMinutes > 0) {
      return Colors.blue; // Task starts in less than 10 minutes
    } else if (difference.inMinutes <= 0 && difference.inMinutes >= -15) {
      return Colors.green; // Task is currently ongoing
    } else if (difference.inMinutes < -15) {
      return Colors.red; // Task is overdue by more than 15 minutes
    } else {
      return Colors.white; // Default color for tasks that are not close to their start time
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _getTaskColor(task.serviceDate),
      child: ListTile(
        title: Text(task.serviceType),
        subtitle: Text(task.clientData),
        onTap: () {
          showDialog(
            context: context,
            builder: (ctx) => TaskPreviewDialog(task),
          );
        },
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
                Navigator.of(context).pushNamed(EditTaskScreen.routeName, arguments: task);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                Provider.of<TaskProvider>(context, listen: false).deleteTask(task.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
