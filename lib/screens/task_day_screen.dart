import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/task_provider.dart';
import '../widgets/task_item.dart';

class TaskDayScreen extends StatelessWidget {
  static const routeName = '/task-day';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Center(child: Text('Debes iniciar sesión para ver tus tareas.'));
    }
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tareas del Día'),
      ),
      body: FutureBuilder(
        future: taskProvider.fetchTasks(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return Center(child: Text('Ocurrió un error.'));
          } else {
            return ListView.builder(
              itemCount: taskProvider.tasksForToday.length,
              itemBuilder: (ctx, i) => TaskItem(taskProvider.tasksForToday[i]),
            );
          }
        },
      ),
    );
  }
}
