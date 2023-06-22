import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pref with ChangeNotifier {
  static final Pref _instance = Pref._internal();
  factory Pref() {
    return _instance;
  }

  Pref._internal() {
    initPrefs();
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences? prefs;

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }
}
