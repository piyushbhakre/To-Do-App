class AuthErrorMapper {
  const AuthErrorMapper._();

  static String login(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Invalid email format.';
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Invalid email or password.';
      default:
        return 'Authentication error: $code';
    }
  }

  static String signup(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'Invalid email format.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      default:
        return 'Authentication error: $code';
    }
  }
}
