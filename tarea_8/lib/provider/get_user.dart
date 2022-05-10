import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarea_2/util/encrypt_function.dart';

class GetUser {
  GetUser._privateConstructor();
  static final GetUser shared = GetUser._privateConstructor();

  Future<Map<String, dynamic>> getUser() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String email = await deencryptText(sharedPreferences.getString('email')!);
    String name = await deencryptText(sharedPreferences.getString('name')!);
    return {
      'email': email,
      'nombre': name,
    };
  }
}
