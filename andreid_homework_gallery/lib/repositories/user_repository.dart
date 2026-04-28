import 'package:andreid_homework_gallery/core/secure_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show PlatformException;

class UserRepository {
  factory UserRepository() {
    return _singleton;
  }

  UserRepository._internal();

  static final UserRepository _singleton = UserRepository._internal();

  static const _pinFallbackKey = 'pinFallbackChosen';

  Future<bool> getPinFallbackChosen() async {
    try {
      final value = await secureStorage.read(key: _pinFallbackKey);
      return value == 'true';
    } on PlatformException {
      return false;
    }
  }

  Future<void> setPinFallbackChosen({required bool value}) async {
    try {
      await secureStorage.write(key: _pinFallbackKey, value: value.toString());
    } on PlatformException catch (e) {
      debugPrint('Error setting pin fallback choice: $e');
    }
  }
}
