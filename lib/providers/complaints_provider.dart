import 'package:flutter/material.dart';
import '../models/complaint.dart';
import '../data/mock_data.dart';

class ComplaintsProvider extends ChangeNotifier {
  late List<Complaint> _complaints;

  ComplaintsProvider() {
    _complaints = List.from(MockData.complaints);
  }

  List<Complaint> get complaints => _complaints;

  Complaint? getById(String id) {
    try {
      return _complaints.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  void accept(String id) {
    final c = getById(id);
    if (c != null) {
      c.status = ComplaintStatus.active;
      c.updatedAt = DateTime.now();
      c.logs.add(LogEntry(time: DateTime.now(), action: 'Complaint accepted and set to active', by: 'Admin'));
      notifyListeners();
    }
  }

  void reject(String id, String reason) {
    final c = getById(id);
    if (c != null) {
      c.status = ComplaintStatus.rejected;
      c.updatedAt = DateTime.now();
      c.notes.add('Rejection reason: $reason');
      c.logs.add(LogEntry(time: DateTime.now(), action: 'Complaint rejected: $reason', by: 'Admin'));
      notifyListeners();
    }
  }

  void assign(String id, String techId) {
    final c = getById(id);
    if (c != null) {
      c.assignedTechnicianId = techId;
      c.updatedAt = DateTime.now();
      c.logs.add(LogEntry(time: DateTime.now(), action: 'Assigned technician $techId', by: 'Admin'));
      notifyListeners();
    }
  }

  void addNote(String id, String note) {
    final c = getById(id);
    if (c != null) {
      c.notes.add(note);
      c.updatedAt = DateTime.now();
      c.logs.add(LogEntry(time: DateTime.now(), action: 'Note added: $note', by: 'Admin'));
      notifyListeners();
    }
  }

  void addPart(String id, String part) {
    final c = getById(id);
    if (c != null) {
      c.parts.add(part);
      c.updatedAt = DateTime.now();
      c.logs.add(LogEntry(time: DateTime.now(), action: 'Part added: $part', by: 'Admin'));
      notifyListeners();
    }
  }

  void updatePriority(String id, Priority priority) {
    final c = getById(id);
    if (c != null) {
      c.priority = priority;
      c.updatedAt = DateTime.now();
      c.logs.add(LogEntry(time: DateTime.now(), action: 'Priority changed to ${priority.name}', by: 'Admin'));
      notifyListeners();
    }
  }
}
