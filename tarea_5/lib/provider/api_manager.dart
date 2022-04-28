import 'dart:convert';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:tarea_2/main.dart';
import 'package:tarea_2/provider/firestore_database_functions.dart';
import 'package:tarea_2/util/app_type.dart';
import 'package:http/http.dart' as http;
import 'package:tarea_2/util/geolocation.dart';

class ApiManager {
  ApiManager._privateConstructor();
  static final ApiManager shared = ApiManager._privateConstructor();

  Future<dynamic> request({
    required String baseUrl,
    required String pathUrl,
    required HttpType type,
    Map<String, dynamic>? bodyParams = const {},
    Map<String, dynamic>? uriParams = const {},
  }) async {
    final uri = Uri.http(baseUrl, pathUrl);
    dynamic response;
    dynamic headers = {
      'Content-Type': 'application/json',
    };
    switch (type) {
      case HttpType.get:
        response = await http.get(uri);
        break;
      case HttpType.post:
        response = await http.post(
          uri,
          body: jsonEncode(bodyParams),
          headers: headers,
        );
        break;
      case HttpType.put:
        response = await http.put(
          uri,
          body: jsonEncode(bodyParams),
          headers: headers,
        );
        break;
      case HttpType.delete:
        response = await http.delete(uri);
        break;
    }
    setGeolocation(baseUrl, pathUrl, bodyParams, uriParams, type, response);
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        return true;
      }
    } else {
      if (response.statusCode == 403) {
        Myapp.isLogin.value = false;
      }
      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
        FirebaseCrashlytics.instance.log(
            "Error: ${baseUrl + pathUrl} - ${response.statusCode.toString()} - ${response.reasonPhrase}");
        FlutterErrorDetails error = FlutterErrorDetails(
          exception: Exception([
            '"Error: ${baseUrl + pathUrl} - ${response.statusCode.toString()} - ${response.reasonPhrase}',
          ]),
          context: ErrorDescription(
              'Error al ingresar al endpoint: ${baseUrl + pathUrl} - ${response.statusCode.toString()}, con los parametros: Body:${bodyParams.toString()}, Uri:${uriParams.toString()}, Type:${type.toString()} por la razon: ${response.reasonPhrase}'),
        );
        FirebaseCrashlytics.instance.recordFlutterError(error);
      } else {
        print("No se pudo enviar el error");
      }
    }
  }

  Future<void> setGeolocation(
      baseUrl, pathUrl, bodyParams, uriParams, type, response) async {
    Map<String, dynamic> data = await getGeolocation(
      baseUrl + pathUrl,
      bodyParams,
      uriParams,
      type,
      response.statusCode,
    );
    FirestoreDatabaseFunctions.shared.addData('geolocation', data);
  }
}
