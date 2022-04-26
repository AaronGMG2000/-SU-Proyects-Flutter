import 'dart:io';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:tarea_2/util/app_type.dart';

Future<Map<String, dynamic>> getDeviceIdentifier() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  Map<String, dynamic> deviceInfoMap = {};
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceInfoMap = {
      'androidId': androidInfo.androidId,
      'display': androidInfo.display,
      'model': androidInfo.model,
      'idDevice': androidInfo.id,
      'isPhysicalDevice': androidInfo.isPhysicalDevice,
    };
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceInfoMap = {
      'identifierForVendor': iosInfo.identifierForVendor,
      'isPhysicalDevice': iosInfo.isPhysicalDevice,
      'name': iosInfo.name,
      'systemName': iosInfo.systemName,
      'systemVersion': iosInfo.systemVersion,
      'model': iosInfo.model,
      'localizedModel': iosInfo.localizedModel,
      'utsname': iosInfo.utsname,
    };
  } else if (kIsWeb) {
    WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
    deviceInfoMap = {
      'vendor': webInfo.vendor,
      'userAgent': webInfo.userAgent,
      'hardwareConcurrency': webInfo.hardwareConcurrency,
    };
  } else if (Platform.isLinux) {
    LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
    deviceInfoMap = {
      'machineId': linuxInfo.machineId,
    };
  }
  return deviceInfoMap;
}

Future<Map<String, dynamic>> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    print('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    print(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  if (permission == LocationPermission.whileInUse ||
      permission == LocationPermission.always) {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    return {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'location': {
        'country': placemarks[0].country,
        'countryCode': placemarks[0].isoCountryCode,
        'locality': placemarks[0].locality,
        'administrativeArea': placemarks[0].administrativeArea,
      },
    };
  }
  return {};
}

Future<Map<String, dynamic>> getGeolocation(
    String url,
    Map<String, dynamic>? bodyParams,
    Map<String, dynamic>? uriParams,
    HttpType type,
    int statusCode) async {
  Map<String, dynamic> deviceInfo = await getDeviceIdentifier();
  Map<String, dynamic> location = await getCurrentLocation();
  Map<String, dynamic> response = {
    'deviceInfo': deviceInfo,
    'location': location,
    'url': url,
    'bodyParams': bodyParams,
    'uriParams': uriParams,
    'type': type.toString(),
    'statusCode': statusCode,
    'timestamp': DateTime.now(),
  };
  return response;
}
