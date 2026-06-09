class Person {
  final int idPerson;
  final String firstName;
  final String? secondName;
  final String firstLastname;
  final String? secondLastname;
  final String email;
  final String phonePrimary;
  final String? phoneSecondary;
  final String createdAt;

  Person({
    required this.idPerson,
    required this.firstName,
    this.secondName,
    required this.firstLastname,
    this.secondLastname,
    required this.email,
    required this.phonePrimary,
    this.phoneSecondary,
    required this.createdAt,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      idPerson: json['id_person'],
      firstName: json['first_name'],
      secondName: json['second_name'],
      firstLastname: json['first_lastname'],
      secondLastname: json['second_lastname'],
      email: json['email'],
      phonePrimary: json['phone_primary'],
      phoneSecondary: json['phone_secondary'],
      createdAt: json['created_at'],
    );
  }

  String get fullName => '$firstName ${secondName ?? ''} $firstLastname ${secondLastname ?? ''}'.trim();
}
