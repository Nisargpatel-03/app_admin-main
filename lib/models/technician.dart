enum TechnicianStatus { available, busy, offline }

class AvailabilitySlot {
  final String day;
  final List<String> slots;
  AvailabilitySlot({required this.day, required this.slots});
}

class Technician {
  final String id, name, phone, email;
  List<String> skills, districts;
  TechnicianStatus status;
  double rating;
  int completedJobs, activeJobs;
  List<AvailabilitySlot> availability;
  final DateTime joinDate;

  Technician({
    required this.id, required this.name, required this.phone, required this.email,
    required this.skills, required this.districts, required this.status,
    required this.rating, required this.completedJobs, required this.activeJobs,
    required this.availability, required this.joinDate,
  });

  Technician copyWith({
    String? name, String? phone, String? email, List<String>? skills,
    List<String>? districts, TechnicianStatus? status,
  }) {
    return Technician(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      skills: skills ?? this.skills,
      districts: districts ?? this.districts,
      status: status ?? this.status,
      rating: rating,
      completedJobs: completedJobs,
      activeJobs: activeJobs,
      availability: availability,
      joinDate: joinDate,
    );
  }
}
