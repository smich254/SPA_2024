import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskPreviewDialog extends StatelessWidget {
  final Task task;

  TaskPreviewDialog(this.task);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Detalles de la Tarea'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tipo de Servicio: ${task.serviceType}'),
          SizedBox(height: 8),
          Text('Monto a Pagar: \$${task.amount.toStringAsFixed(2)}'),
          SizedBox(height: 8),
          Text('Datos del Cliente: ${task.clientData}'),
          SizedBox(height: 8),
          Text('Fecha y Hora: ${task.serviceDate.toString()}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cerrar'),
        ),
      ],
    );
  }
}
