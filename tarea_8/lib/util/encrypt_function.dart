import 'package:encrypt/encrypt.dart';
import 'package:tarea_2/util/realTimeDatabase.dart';

Future<String> encryptText(String text) async {
  final String? deviceId = await getDeviceIdentifier();
  final key = Key.fromUtf8(deviceId!);
  final iv = IV.fromLength(16);

  final encrypter = Encrypter(AES(key));
  return encrypter.encrypt(text, iv: iv).base64;
}

Future<String> deencryptText(String text) async {
  final String? deviceId = await getDeviceIdentifier();
  final key = Key.fromUtf8(deviceId!);
  final iv = IV.fromLength(16);

  final encrypter = Encrypter(AES(key));
  return encrypter.decrypt64(text, iv: iv);
}
