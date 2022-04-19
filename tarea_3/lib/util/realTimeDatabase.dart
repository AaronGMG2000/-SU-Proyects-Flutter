import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

Future<String?> getDeviceIdentifier() async {
  String? deviceIdentifier = "unknown";
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceIdentifier = androidInfo.androidId;
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceIdentifier = iosInfo.identifierForVendor;
  } else if (kIsWeb) {
    WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
    deviceIdentifier = webInfo.vendor! +
        webInfo.userAgent! +
        webInfo.hardwareConcurrency.toString();
  } else if (Platform.isLinux) {
    LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
    deviceIdentifier = linuxInfo.machineId;
  }
  return deviceIdentifier;
}

Future<void> setMode(dynamic value, String addres) async {
  final database = FirebaseDatabase.instance.ref();
  String? macAddress = await getDeviceIdentifier();
  final mode = database.child('$macAddress/$addres');
  mode.set(value);
}

Future<dynamic> getMode(String addres) async {
  final database = FirebaseDatabase.instance.ref();
  String? macAddress = await getDeviceIdentifier();
  final mode = database.child('$macAddress/$addres');
  return await mode.onValue.first;
}
