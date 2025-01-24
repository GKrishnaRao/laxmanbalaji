import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
//import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class NetworkHandler {
  //var log = Logger();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // GET
  Future get(String url) async {
    // final SharedPreferences prefs = await _prefs;
    // String? token = prefs.getString('token');
    var response = await http.get(
      Uri.parse(url),
      // headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      //log.i(response.body);
      return response; //json.decode(response.body);
    }
    //log.i(response.body);
    //log.i(response.statusCode);
  }

  // POST
  Future<http.Response> post(String url, Map<String, String> body) async {
    //final SharedPreferences prefs = await _prefs;
    //String? token = prefs.getString('token');
    //log.d(body);
    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-type": "application/x-www-form-urlencoded",
        //"Authorization": "Bearer $token"
      },
      body: body,
    );
    print(response.body);
    return response;
  }

  Future<http.Response> patch(String url, Map<String, String> body) async {
    final SharedPreferences prefs = await _prefs;
    String? token = prefs.getString('token');
    //log.d(body);
    var response = await http.patch(
      Uri.parse(url),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode(body),
    );
    return response;
  }

  Future<http.Response> post1(String url, var body) async {
    final SharedPreferences prefs = await _prefs;
    String? token = prefs.getString('token');
    //log.d(body);
    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode(body),
    );
    return response;
  }

  // Multipart Images
  Future<http.StreamedResponse> patchImage(String url, String filepath) async {
    final SharedPreferences prefs = await _prefs;
    String? token = prefs.getString('token');
    var request = http.MultipartRequest('PATCH', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath("img", filepath));
    request.headers.addAll({
      "Content-type": "multipart/form-data",
      "Authorization": "Bearer $token"
    });
    var response = request.send();
    return response;
  }

  NetworkImage getImage(String url) {
    return NetworkImage(url);
  }
}
