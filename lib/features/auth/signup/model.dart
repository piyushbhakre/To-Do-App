class SignupModel {
  const SignupModel({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  final String username;
  final String email;
  final String password;
  final String confirmPassword;

  bool get isValid =>
      username.trim().isNotEmpty &&
      email.trim().isNotEmpty &&
      password.isNotEmpty &&
      confirmPassword.isNotEmpty;
}
