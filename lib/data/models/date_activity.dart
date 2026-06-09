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
      idDateActivity: json['Id_dateActivity'] ?? json['id_date_activity'] ?? 0,
      startDate: json['Start_date'] ?? json['start_date'] ?? '',
      endDate: json['End_date'] ?? json['end_date'] ?? '',
      idActivity: json['Id_activity'] ?? json['id_activity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id_dateActivity': idDateActivity,
      'Start_date': startDate,
      'End_date': endDate,
      'Id_activity': idActivity,
    };
  }
}
