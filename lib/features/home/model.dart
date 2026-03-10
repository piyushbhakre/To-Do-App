class HomeModel {
  const HomeModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.encryptedPassword,
  });

  final String uid;
  final String email;
  final String username;
  final String encryptedPassword;

  factory HomeModel.fromMap(Map<String, dynamic> map) {
    return HomeModel(
      uid: (map['uid'] ?? '-') as String,
      email: (map['email'] ?? '-') as String,
      username: (map['username'] ?? '-') as String,
      encryptedPassword: (map['encryptedPassword'] ?? '-') as String,
    );
  }
}
