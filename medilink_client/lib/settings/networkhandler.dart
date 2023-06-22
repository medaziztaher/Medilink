import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../utils/constatnts.dart';
import '../utils/global.dart';
import '../utils/prefs.dart';
class NetworkHandler {
  final prefs = Pref();
  var log = Logger();

  Future<dynamic> get(String url) async {
    final baseurl = Uri.parse(url);
    final String? file = globalToken;
    String? token;

    if (file != null) {
      token = file;
    } else {
      token = prefs.prefs!.getString(kTokenSave);
    }

    try {
      var response = await http.get(
        baseurl,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log.i(response.body);
        return json.decode(response.body);
      } else {
        log.i(response.body);
        log.i(response.statusCode);
        return null;
      }
    } catch (e) {
      log.e(e.toString());
      return null;
    }
  }

  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    final baseurl = Uri.parse(url);
    final String? file = globalToken;
    String? token;

    if (file != null) {
      token = file;
    } else {
      token = prefs.prefs!.getString(kTokenSave);
    }

    var response = await http.post(
      baseurl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode(body),
    );
    return response;
  }

  Future<http.Response> put(String url, Map<String, dynamic> body) async {
    final baseurl = Uri.parse(url);
    final String? file = globalToken;
    String? token;

    if (file != null) {
      token = file;
    } else {
      token = prefs.prefs!.getString(kTokenSave);
    }

    log.d(body);
    var response = await http.put(
      baseurl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode(body),
    );
    return response;
  }



  Future<http.StreamedResponse> patchImage(String url, String filePath) async {
    final String? file = globalToken;
    String? token;
    if (file != null) {
      token = file;
    } else {
      token = prefs.prefs!.getString(kTokenSave);
    }
    var request = http.MultipartRequest('PATCH', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token'
    });
    var response = request.send();
    return response;
  }
}
