class Task {
  String id;
  String serviceType;
  double amount;
  String clientData;
  DateTime serviceDate;
  bool isDone;

  Task({
    required this.id,
    required this.serviceType,
    required this.amount,
    required this.clientData,
    required this.serviceDate,
    this.isDone = false,
  });
}
