import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  static const String _key = 'api_url';
  static String apiUrl = '';

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    apiUrl = prefs.getString(_key) ?? '';
  }

  static Future<void> setApiUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, url);
    apiUrl = url;
  }
}

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();
