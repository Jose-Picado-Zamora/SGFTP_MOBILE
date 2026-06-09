class DateActivity {
  final int idDateActivity;
  final String startDate;
  final String endDate;
  final int idActivity;

  DateActivity({
    required this.idDateActivity,
    required this.startDate,
    required this.endDate,
    required this.idActivity,
  });

  factory DateActivity.fromJson(Map<String, dynamic> json) {
    return DateActivity(
      idDateActivity: json['id_date_activity'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      idActivity: json['id_activity'],
    );
  }
}
