import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'package:intl/intl.dart';

class TaskForm extends StatefulWidget {
  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late String _serviceType;
  late double _amount;
  late String _clientData;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void _presentDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _presentTimePicker() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _submitData() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_selectedDate == null || _selectedTime == null) {
      // Show some error message
      return;
    }

    _formKey.currentState!.save();
    final DateTime serviceDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final newTask = Task(
      id: DateTime.now().toString(),
      serviceType: _serviceType,
      amount: _amount,
      clientData: _clientData,
      serviceDate: serviceDateTime,
    );

    Provider.of<TaskProvider>(context, listen: false).addTask(newTask);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Tipo de Servicio'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingrese el tipo de servicio.';
                    }
                    return null;
                  },
                  onSaved: (value) => _serviceType = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Monto a Pagar'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty || double.tryParse(value) == null) {
                      return 'Por favor ingrese un monto válido.';
                    }
                    return null;
                  },
                  onSaved: (value) => _amount = double.parse(value!),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Datos del Cliente'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingrese los datos del cliente.';
                    }
                    return null;
                  },
                  onSaved: (value) => _clientData = value!,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No se ha seleccionado fecha'
                            : 'Fecha: ${DateFormat.yMd().format(_selectedDate!)}',
                      ),
                    ),
                    TextButton(
                      onPressed: _presentDatePicker,
                      child: Text(
                        'Seleccionar Fecha',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedTime == null
                            ? 'No se ha seleccionado hora'
                            : 'Hora: ${_selectedTime!.format(context)}',
                      ),
                    ),
                    TextButton(
                      onPressed: _presentTimePicker,
                      child: Text(
                        'Seleccionar Hora',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('Agregar Tarea'),
                  onPressed: _submitData,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
