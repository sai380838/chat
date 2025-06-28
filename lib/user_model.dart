class UserModel {
  final String email;
  final String displayName;
  final String mobile;
  final String country;
  final String token;

  UserModel({
    required this.email,
    required this.displayName,
    required this.mobile,
    required this.country,
    required this.token,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'displayName': displayName,
    'mobile': mobile,
    'country': country,
    'token': token,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    email: json['email'],
    displayName: json['displayName'],
    mobile: json['mobile'],
    country: json['country'],
    token: json['token'],
  );
}
