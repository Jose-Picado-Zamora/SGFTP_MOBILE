class ActivityEnrollment {
  final int idEnrollmentActivity;
  final int idVolunteer;
  final int idActivity;
  final String enrollmentDate;
  final String status;
  final String? attendanceDate;
  final String updatedAt;

  ActivityEnrollment({
    required this.idEnrollmentActivity,
    required this.idVolunteer,
    required this.idActivity,
    required this.enrollmentDate,
    required this.status,
    this.attendanceDate,
    required this.updatedAt,
  });

  factory ActivityEnrollment.fromJson(Map<String, dynamic> json) {
    return ActivityEnrollment(
      idEnrollmentActivity: json['id_enrollment_activity'],
      idVolunteer: json['id_volunteer'],
      idActivity: json['id_activity'],
      enrollmentDate: json['enrollment_date'],
      status: json['status'],
      attendanceDate: json['attendance_date'],
      updatedAt: json['updated_at'],
    );
  }

  bool get isAttended => status == 'attended';
  bool get isPending => status == 'pending';
  bool get isCancelled => status == 'cancelled';
}
