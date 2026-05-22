import 'package:cloud_firestore/cloud_firestore.dart';

enum ComplaintStatus { pending, active, completed, rejected }
enum Priority { low, medium, high, critical }

class Customer {
  final String name, phone, email;
  Customer({required this.name, required this.phone, required this.email});

  Map<String, dynamic> toMap() => {
    'name': name,
    'phone': phone,
    'email': email,
  };

  factory Customer.fromMap(Map<String, dynamic> map) => Customer(
    name: map['name'] ?? '',
    phone: map['phone'] ?? '',
    email: map['email'] ?? '',
  );
}

class Device {
  final String type, brand, model, serial, purchaseDate, warrantyExpiry;
  Device({
    required this.type, required this.brand, required this.model,
    required this.serial, required this.purchaseDate, required this.warrantyExpiry,
  });

  Map<String, dynamic> toMap() => {
    'type': type,
    'brand': brand,
    'model': model,
    'serial': serial,
    'purchaseDate': purchaseDate,
    'warrantyExpiry': warrantyExpiry,
  };

  factory Device.fromMap(Map<String, dynamic> map) => Device(
    type: map['type'] ?? '',
    brand: map['brand'] ?? '',
    model: map['model'] ?? '',
    serial: map['serial'] ?? '',
    purchaseDate: map['purchaseDate'] ?? '',
    warrantyExpiry: map['warrantyExpiry'] ?? '',
  );
}

class LogEntry {
  final DateTime time;
  final String action, by;
  LogEntry({required this.time, required this.action, required this.by});

  Map<String, dynamic> toMap() => {
    'time': Timestamp.fromDate(time),
    'action': action,
    'by': by,
  };

  factory LogEntry.fromMap(Map<String, dynamic> map) => LogEntry(
    time: (map['time'] as Timestamp?)?.toDate() ?? DateTime.now(),
    action: map['action'] ?? '',
    by: map['by'] ?? '',
  );
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

  Map<String, dynamic> toMap() => {
    'id': id,
    'ticketNo': ticketNo,
    'customer': customer.toMap(),
    'device': device.toMap(),
    'issue': issue,
    'description': description,
    'status': status.name,
    'priority': priority.name,
    'district': district,
    'address': address,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
    'assignedTechnicianId': assignedTechnicianId,
    'attachments': attachments,
    'notes': notes,
    'parts': parts,
    'logs': logs.map((l) => l.toMap()).toList(),
  };

  factory Complaint.fromMap(Map<String, dynamic> map) => Complaint(
    id: map['id'] ?? '',
    ticketNo: map['ticketNo'] ?? map['ticket_no'] ?? '',
    customer: Customer.fromMap(map['customer'] is Map ? Map<String, dynamic>.from(map['customer']) : {}),
    device: Device.fromMap(map['device'] is Map ? Map<String, dynamic>.from(map['device']) : {}),
    issue: map['issue'] ?? '',
    description: map['description'] ?? '',
    status: ComplaintStatus.values.firstWhere((e) => e.name == map['status'], orElse: () => ComplaintStatus.pending),
    priority: Priority.values.firstWhere((e) => e.name == map['priority'], orElse: () => Priority.medium),
    district: map['district'] ?? '',
    address: map['address'] ?? '',
    createdAt: (map['createdAt'] is Timestamp) ? (map['createdAt'] as Timestamp).toDate() : DateTime.now(),
    updatedAt: (map['updatedAt'] is Timestamp) ? (map['updatedAt'] as Timestamp).toDate() : DateTime.now(),
    assignedTechnicianId: map['assignedTechnicianId'],
    attachments: List<String>.from(map['attachments'] ?? []),
    notes: List<String>.from(map['notes'] ?? []),
    parts: List<String>.from(map['parts'] ?? []),
    logs: (map['logs'] as List?)?.map((l) => LogEntry.fromMap(Map<String, dynamic>.from(l))).toList() ?? [],
  );
}
