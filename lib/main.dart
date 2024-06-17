import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/task_provider.dart';
import './screens/task_list_screen.dart';
import './screens/task_day_screen.dart';
import './screens/task_summary_screen.dart';
import './screens/home_screen.dart';
import './screens/edit_task_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => TaskProvider(),
      child: MaterialApp(
        title: 'Control de Servicios del Spa',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
        routes: {
          TaskDayScreen.routeName: (ctx) => TaskDayScreen(),
          TaskSummaryScreen.routeName: (ctx) => TaskSummaryScreen(),
          EditTaskScreen.routeName: (ctx) => EditTaskScreen(),
        },
      ),
    );
  }
}
