import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../services/networkhandler.dart';
import '../services/path.dart';
import '../utils/constatnts.dart';
import '../utils/global.dart';
import '../utils/prefs.dart';

final prefs = Pref();
NetworkHandler networkHandler = NetworkHandler();

Future<String?> queryUserRole() async {
  final baseurl = Uri.parse(userData);
  final String? file = globalToken;
  String? token;

  if (file != null) {
    token = file;
  } else {
    token = prefs.prefs!.getString(kTokenSave);
  }
  final response = await http.get(
    baseurl,
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    final data = json.decode(response.body);
    final user = User.fromJson(data['data']);
    print(user.role);
    return user.role;
  } else {
    print('Error with server request.');
    return null;
  }
}

Future<String?> queryHealthcareProvdierType() async {
  final baseurl = Uri.parse(userData);
  final String? file = globalToken;
  String? token;

  if (file != null) {
    token = file;
  } else {
    token = prefs.prefs!.getString(kTokenSave);
  }
  final response = await http.get(
    baseurl,
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    final data = json.decode(response.body);
    final user = User.fromJson(data['data']);
    if (user.role == "HealthcareProvider") {
      final provider = User.fromJson(data['data']);
      return provider.type;
    }
  }
  return null;
}

Future<String?> queryUserID() async {
  final baseurl = Uri.parse(userData);
  final String? file = globalToken;
  String? token;

  if (file != null) {
    token = file;
  } else {
    token = prefs.prefs!.getString(kTokenSave);
  }
  final response = await http.get(
    baseurl,
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    final data = json.decode(response.body);
    final user = User.fromJson(data['data']);
    return user.id;
  } else {
    print('Error with server request.');
    return null;
  }
}

Future<void> pushDeviceToken() async {
  final String? id = globalUserId;
  String? userId;

  if (id != null) {
    userId = id;
  } else {
    userId = await queryUserID();
  }

  Map<String, String> data = {'token': globalDeviceToken!};

  if (userId != null) {
    try {
      await networkHandler.put("$userData/$userId/device-token", data);
      print('Device token updated successfully');
      return;
    } catch (e) {
      print('Error updating device token: $e');
      return;
    }
  } else {
    print('User ID is null');
    return;
  }
}
