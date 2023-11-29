class AdminAccount {
  final String username;
  final String school;
  final String password;

  AdminAccount({
    required this.username,
    required this.school,
    required this.password,
  });

  factory AdminAccount.fromJson(Map<String, dynamic> json) {
    return AdminAccount(
      username: json['fields']['username']['stringValue'],
      school: json['fields']['school']['stringValue'],
      password: json['fields']['password']['stringValue'],
    );
  }
}
