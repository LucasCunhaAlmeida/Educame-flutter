import 'dart:convert';

import 'package:crypto/crypto.dart';

class PasswordHasher {
  static String hash(String password) {
    final bytes = utf8.encode(password);

    final digest = sha256.convert(bytes);

    return digest.toString();
  }

  static bool verify({
    required String password,
    required String hashedPassword,
  }) {
    final passwordHash = hash(password);

    return passwordHash == hashedPassword;
  }
}