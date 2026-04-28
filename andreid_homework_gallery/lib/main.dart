import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(AppRouter());
}


Future<SharedPreferences?> _initializeSharedPreferences() async {
  try {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref;
  } on Exception {
    return null;
  }
}


