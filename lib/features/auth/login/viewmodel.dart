import 'package:firebase_auth/firebase_auth.dart';
import 'package:herody_assignment/core/services/auth_service.dart';
import 'package:herody_assignment/core/utils/auth_error_mapper.dart';
import 'package:herody_assignment/features/auth/login/model.dart';

class LoginViewModel {
  LoginViewModel({AuthService? authService})
      : _authService = authService ?? AuthService();

  final AuthService _authService;

  Future<String?> login(LoginModel model) async {
    if (!model.isValid) {
      return 'Email and password are required.';
    }

    try {
      await _authService.login(
        email: model.email.trim(),
        password: model.password,
      );
      return null;
    } on FirebaseAuthException catch (error) {
      return AuthErrorMapper.login(error.code);
    } catch (_) {
      return 'Login failed. Please try again.';
    }
  }
}
