import 'dart:convert';
import 'dart:math';

import 'package:hex/hex.dart';
import 'package:password_manager_r1/models/hash_length.dart';
import 'package:password_manager_r1/models/password_data.dart';
import 'package:sha3/sha3.dart';

class Encryption {
  static final Random _random = Random.secure();

  static const int DEFAULT_COUNT = 256;

  // Generates a default salt with 32 characters
  static String defaultSaltGen() {
    var values = List<int>.generate(24, (index) => _random.nextInt(256));
    var result = base64Url.encode(values);

    return result;
  }

  static String encryptSHA3(
      String masterPassword, String salt, int count, HashLength length) {
    String resultingHash = masterPassword + salt;

    for (int i = 0; i < count; i++) {
      var k = SHA3(256, SHA3_PADDING, length.sha3OutputBits());
      k.update(utf8.encode(resultingHash));
      var hash = k.digest();
      resultingHash = HEX.encode(hash);
    }

    return resultingHash;
  }

  static String encryptSHA3FromData(
      String masterPassword, PasswordData passwordData) {
    String resultingHash;
    try {
      resultingHash = masterPassword + passwordData.salt;

      for (int i = 0; i < passwordData.count; i++) {
        var k = SHA3(256, SHA3_PADDING, passwordData.length.sha3OutputBits());
        k.update(utf8.encode(resultingHash));
        var hash = k.digest();
        resultingHash = HEX.encode(hash);
      }
    } catch (e) {
      throw Exception('Could not generate hash:\n$e');
    }

    return resultingHash;
  }
}
