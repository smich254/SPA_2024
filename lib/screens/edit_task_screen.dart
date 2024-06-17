import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'package:intl/intl.dart';

class EditTaskScreen extends StatefulWidget {
  static const routeName = '/edit-task';

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _id;
  late String _serviceType;
  late double _amount;
  late String _clientData;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final task = ModalRoute.of(context)!.settings.arguments as Task;
    _id = task.id;
    _serviceType = task.serviceType;
    _amount = task.amount;
    _clientData = task.clientData;
    _selectedDate = task.serviceDate;
    _selectedTime = TimeOfDay(hour: task.serviceDate.hour, minute: task.serviceDate.minute);
  }

  void _presentDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
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
      initialTime: _selectedTime ?? TimeOfDay.now(),
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

    final editedTask = Task(
      id: _id,
      serviceType: _serviceType,
      amount: _amount,
      clientData: _clientData,
      serviceDate: serviceDateTime,
    );

    Provider.of<TaskProvider>(context, listen: false).editTask(_id, editedTask);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: _serviceType,
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
                  initialValue: _amount.toString(),
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
                  initialValue: _clientData,
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
                  child: Text('Guardar Cambios'),
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
