class User {
  final int idUser;
  final int idPerson;
  final int status;
  final int isEmailVerified;
  final int failedLoginAttempts;
  final String createdAt;
  final String updatedAt;
  final String? activationToken;

  User({
    required this.idUser,
    required this.idPerson,
    required this.status,
    required this.isEmailVerified,
    required this.failedLoginAttempts,
    required this.createdAt,
    required this.updatedAt,
    this.activationToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idUser: json['id_user'],
      idPerson: json['id_person'],
      status: json['status'],
      isEmailVerified: json['is_email_verified'],
      failedLoginAttempts: json['failed_login_attempts'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      activationToken: json['activation_token'],
    );
  }

  bool get isActive => status == 1;
  bool get isEmailVerifiedBool => isEmailVerified == 1;
}
