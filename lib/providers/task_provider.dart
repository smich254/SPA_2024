import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Importación de intl para formateo de fechas
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => [..._tasks];

  Future<void> fetchTasks() async {
    final user = FirebaseAuth.instance.currentUser!;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .get();
    _tasks = snapshot.docs
        .map((doc) => Task(
              id: doc.id,
              serviceType: doc['serviceType'],
              amount: doc['amount'],
              clientData: doc['clientData'],
              serviceDate: (doc['serviceDate'] as Timestamp).toDate(),
              isDone: doc['isDone'],
            ))
        .toList();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    final user = FirebaseAuth.instance.currentUser!;
    final docRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .add({
      'serviceType': task.serviceType,
      'amount': task.amount,
      'clientData': task.clientData,
      'serviceDate': task.serviceDate,
      'isDone': task.isDone,
    });
    _tasks.add(Task(
      id: docRef.id,
      serviceType: task.serviceType,
      amount: task.amount,
      clientData: task.clientData,
      serviceDate: task.serviceDate,
      isDone: task.isDone,
    ));
    notifyListeners();
  }

  Future<void> editTask(String id, Task newTask) async {
    final user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .doc(id)
        .update({
      'serviceType': newTask.serviceType,
      'amount': newTask.amount,
      'clientData': newTask.clientData,
      'serviceDate': newTask.serviceDate,
      'isDone': newTask.isDone,
    });
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex >= 0) {
      _tasks[taskIndex] = newTask;
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    final user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .doc(id)
        .delete();
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  Future<void> toggleTaskStatus(String id) async {
    final user = FirebaseAuth.instance.currentUser!;
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index].isDone = !_tasks[index].isDone;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .doc(id)
          .update({'isDone': _tasks[index].isDone});
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
