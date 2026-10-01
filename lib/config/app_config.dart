import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  // static const String _key = 'api_url';

  //celular fisico (cmd: adb reverse tcp:8081 tcp:8081)
  static String apiUrl = 'http://localhost:8081';

  //Emulador
  // static String apiUrl = 'http://10.0.2.2:8081';

  // static Future<void> init() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   apiUrl = prefs.getString(_key) ?? '';
  // }

  // static Future<void> setApiUrl(String url) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString(_key, url);
  //   apiUrl = url;
  // }
}

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();
