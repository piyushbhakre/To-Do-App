import 'package:firebase_auth/firebase_auth.dart';
import 'package:herody_assignment/core/security/password_hasher.dart';
import 'package:herody_assignment/core/services/auth_service.dart';
import 'package:herody_assignment/core/services/user_profile_service.dart';
import 'package:herody_assignment/core/utils/auth_error_mapper.dart';
import 'package:herody_assignment/features/auth/signup/model.dart';

class SignupViewModel {
  SignupViewModel({
    AuthService? authService,
    UserProfileService? userProfileService,
  })  : _authService = authService ?? AuthService(),
        _userProfileService = userProfileService ?? UserProfileService();

  final AuthService _authService;
  final UserProfileService _userProfileService;

  Future<String?> signup(SignupModel model) async {
    if (!model.isValid) {
      return 'All fields are required.';
    }

    if (model.password != model.confirmPassword) {
      return 'Password and confirm password do not match.';
    }

    try {
      final credential = await _authService.signup(
        email: model.email.trim(),
        password: model.password,
      );

      final user = credential.user;
      if (user == null) {
        return 'Signup failed. Please try again.';
      }

      final encryptedPassword = PasswordHasher.hashSha256(model.password);

      await _userProfileService.createUserProfile(
        uid: user.uid,
        username: model.username.trim(),
        email: model.email.trim(),
        encryptedPassword: encryptedPassword,
      );

      return null;
    } on FirebaseAuthException catch (error) {
      return AuthErrorMapper.signup(error.code);
    } catch (_) {
      return 'Signup failed. Please try again.';
    }
  }
}
