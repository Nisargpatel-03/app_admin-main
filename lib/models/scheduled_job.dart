class ScheduledJob {
  final String id, technicianId, complaintId;
  final String date, time;
  final double duration;
  final String customer, district, issue;

  ScheduledJob({
    required this.id, required this.technicianId, required this.complaintId,
    required this.date, required this.time, required this.duration,
    required this.customer, required this.district, required this.issue,
  });
}
