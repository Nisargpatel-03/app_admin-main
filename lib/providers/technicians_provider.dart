import 'package:flutter/material.dart';
import '../models/technician.dart';
import '../data/mock_data.dart';

class TechniciansProvider extends ChangeNotifier {
  late List<Technician> _technicians;

  TechniciansProvider() {
    _technicians = List.from(MockData.technicians);
  }

  List<Technician> get technicians => _technicians;

  Technician? getById(String id) {
    try {
      return _technicians.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  void add(Technician tech) {
    _technicians.add(tech);
    notifyListeners();
  }

  void update(String id, {String? name, String? phone, String? email, List<String>? skills, List<String>? districts, TechnicianStatus? status}) {
    final idx = _technicians.indexWhere((t) => t.id == id);
    if (idx != -1) {
      _technicians[idx] = _technicians[idx].copyWith(
        name: name, phone: phone, email: email,
        skills: skills, districts: districts, status: status,
      );
      notifyListeners();
    }
  }

  void delete(String id) {
    _technicians.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void cycleStatus(String id) {
    final tech = getById(id);
    if (tech != null) {
      final nextStatus = {
        TechnicianStatus.available: TechnicianStatus.busy,
        TechnicianStatus.busy: TechnicianStatus.offline,
        TechnicianStatus.offline: TechnicianStatus.available,
      };
      update(id, status: nextStatus[tech.status]);
    }
  }
}
