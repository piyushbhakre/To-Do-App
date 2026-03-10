import 'dart:convert';

import 'package:crypto/crypto.dart';

class PasswordHasher {
  const PasswordHasher._();

  static String hashSha256(String rawPassword) {
    return sha256.convert(utf8.encode(rawPassword)).toString();
  }
}
