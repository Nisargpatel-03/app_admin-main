import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/complaint.dart';
import '../data/mock_data.dart';

class ComplaintsProvider extends ChangeNotifier {
  List<Complaint> _complaints = [];
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  bool _isLoading = true;

  ComplaintsProvider() {
    _listenToComplaints();
  }

  List<Complaint> get complaints => _complaints;
  bool get isLoading => _isLoading;

  void _listenToComplaints() {
    _db.collection('complaints').snapshots().listen((snapshot) async {
      if (snapshot.docs.isEmpty) {
        // Optional: Seed mock data if collection is empty
        await _seedMockData();
      } else {
        _complaints = snapshot.docs.map((doc) {
          final data = Map<String, dynamic>.from(doc.data());
          // Ensure the document ID is always set in the model
          if (data['id'] == null || data['id'].toString().isEmpty) {
            data['id'] = doc.id;
          }
          return Complaint.fromMap(data);
        }).toList();
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  Future<void> _seedMockData() async {
    for (var complaint in MockData.complaints) {
      await _db.collection('complaints').doc(complaint.id).set(complaint.toMap());
    }
  }

  Future<void> addComplaint(Complaint complaint) async {
    await _db.collection('complaints').doc(complaint.id).set(complaint.toMap());
  }

  Future<void> deleteComplaint(String id) async {
    await _db.collection('complaints').doc(id).delete();
  }

  Complaint? getById(String id) {
    try {
      return _complaints.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> accept(String id) async {
    final c = getById(id);
    if (c != null) {
      final updatedLogs = List<LogEntry>.from(c.logs)
        ..add(LogEntry(time: DateTime.now(), action: 'Complaint accepted', by: 'Admin'));
      
      await _db.collection('complaints').doc(id).update({
        'status': ComplaintStatus.active.name,
        'updatedAt': Timestamp.now(),
        'logs': updatedLogs.map((l) => l.toMap()).toList(),
      });
    }
  }

  Future<void> reject(String id, String reason) async {
    final c = getById(id);
    if (c != null) {
      final updatedNotes = List<String>.from(c.notes)..add('Rejection reason: $reason');
      final updatedLogs = List<LogEntry>.from(c.logs)
        ..add(LogEntry(time: DateTime.now(), action: 'Complaint rejected: $reason', by: 'Admin'));

      await _db.collection('complaints').doc(id).update({
        'status': ComplaintStatus.rejected.name,
        'updatedAt': Timestamp.now(),
        'notes': updatedNotes,
        'logs': updatedLogs.map((l) => l.toMap()).toList(),
      });
    }
  }

  Future<void> assign(String id, String techId) async {
    final c = getById(id);
    if (c != null) {
      final updatedLogs = List<LogEntry>.from(c.logs)
        ..add(LogEntry(time: DateTime.now(), action: 'Assigned to technician: $techId', by: 'Admin'));

      final updates = {
        'assignedTechnicianId': techId,
        'updatedAt': Timestamp.now(),
        'logs': updatedLogs.map((l) => l.toMap()).toList(),
      };

      // If assigning, also set to active if it was pending
      if (c.status == ComplaintStatus.pending) {
        updates['status'] = ComplaintStatus.active.name;
      }

      await _db.collection('complaints').doc(id).update(updates);
    }
  }

  Future<void> addNote(String id, String note) async {
    final c = getById(id);
    if (c != null) {
      final updatedNotes = List<String>.from(c.notes)..add(note);
      final updatedLogs = List<LogEntry>.from(c.logs)
        ..add(LogEntry(time: DateTime.now(), action: 'Note added: $note', by: 'Admin'));

      await _db.collection('complaints').doc(id).update({
        'notes': updatedNotes,
        'updatedAt': Timestamp.now(),
        'logs': updatedLogs.map((l) => l.toMap()).toList(),
      });
    }
  }

  Future<void> addPart(String id, String part) async {
    final c = getById(id);
    if (c != null) {
      final updatedParts = List<String>.from(c.parts)..add(part);
      final updatedLogs = List<LogEntry>.from(c.logs)
        ..add(LogEntry(time: DateTime.now(), action: 'Part added: $part', by: 'Admin'));

      await _db.collection('complaints').doc(id).update({
        'parts': updatedParts,
        'updatedAt': Timestamp.now(),
        'logs': updatedLogs.map((l) => l.toMap()).toList(),
      });
    }
  }

  Future<void> updatePriority(String id, Priority priority) async {
    final c = getById(id);
    if (c != null) {
      final updatedLogs = List<LogEntry>.from(c.logs)
        ..add(LogEntry(time: DateTime.now(), action: 'Priority changed to ${priority.name}', by: 'Admin'));

      await _db.collection('complaints').doc(id).update({
        'priority': priority.name,
        'updatedAt': Timestamp.now(),
        'logs': updatedLogs.map((l) => l.toMap()).toList(),
      });
    }
  }
}
