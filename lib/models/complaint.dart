enum ComplaintStatus { pending, active, completed, rejected }
enum Priority { low, medium, high, critical }

class Customer {
  final String name, phone, email;
  Customer({required this.name, required this.phone, required this.email});
}

class Device {
  final String type, brand, model, serial, purchaseDate, warrantyExpiry;
  Device({
    required this.type, required this.brand, required this.model,
    required this.serial, required this.purchaseDate, required this.warrantyExpiry,
  });
}

class LogEntry {
  final DateTime time;
  final String action, by;
  LogEntry({required this.time, required this.action, required this.by});
}

class Complaint {
  final String id, ticketNo;
  final Customer customer;
  final Device device;
  final String issue, description;
  ComplaintStatus status;
  Priority priority;
  final String district, address;
  final DateTime createdAt;
  DateTime updatedAt;
  String? assignedTechnicianId;
  List<String> attachments, notes, parts;
  List<LogEntry> logs;

  Complaint({
    required this.id, required this.ticketNo, required this.customer,
    required this.device, required this.issue, required this.description,
    required this.status, required this.priority, required this.district,
    required this.address, required this.createdAt, required this.updatedAt,
    this.assignedTechnicianId,
    List<String>? attachments, List<String>? notes, List<String>? parts,
    List<LogEntry>? logs,
  })  : attachments = attachments ?? [],
        notes = notes ?? [],
        parts = parts ?? [],
        logs = logs ?? [];
}
