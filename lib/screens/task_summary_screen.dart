import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/task_provider.dart';

class TaskSummaryScreen extends StatelessWidget {
  static const routeName = '/task-summary';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Center(child: Text('Debes iniciar sesión para ver tus tareas.'));
    }

    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Resumen de Tareas'),
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
              itemCount: taskProvider.doneTasks.length,
              itemBuilder: (ctx, i) => ListTile(
                title: Text(taskProvider.doneTasks[i].serviceType),
                subtitle: Text(taskProvider.doneTasks[i].clientData),
                trailing: Text('\$${taskProvider.doneTasks[i].amount.toStringAsFixed(2)}'),
              ),
            );
          }
        },
      ),
    );
  }
}

