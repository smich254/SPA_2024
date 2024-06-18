import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './screens/home_screen.dart';
import './screens/login_screen.dart';
import './providers/task_provider.dart';
import './screens/edit_task_screen.dart';
import './screens/task_day_screen.dart';
import './screens/task_summary_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (userSnapshot.hasData) {
              return HomeScreen();
            }
            return LoginScreen();
          },
        ),
        routes: {
          HomeScreen.routeName: (ctx) => HomeScreen(),
          TaskDayScreen.routeName: (ctx) => TaskDayScreen(),
          TaskSummaryScreen.routeName: (ctx) => TaskSummaryScreen(),
          EditTaskScreen.routeName: (ctx) => EditTaskScreen(),
        },
      ),
    );
  }
}
