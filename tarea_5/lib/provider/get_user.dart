import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarea_2/main.dart';
import 'package:tarea_2/util/realTimeDatabase.dart';

class GetUser {
  GetUser._privateConstructor();
  static final GetUser shared = GetUser._privateConstructor();

  Future<Map<String, dynamic>> getUser() async {
    if (Myapp.connected.value) {
      dynamic isEmail = await getMode("email");
      dynamic isName = await getMode("name");
      if (isEmail.snapshot.value != null && isName.snapshot.value != null) {
        return {
          'email': isEmail.snapshot.value,
          'nombre': isName.snapshot.value,
        };
      }
      return {
        'email': 'undefinded',
        'nombre': 'undefined',
      };
    } else {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String email = sharedPreferences.getString('email')!;
      String name = sharedPreferences.getString('name')!;
      return {
        'email': email,
        'nombre': name,
      };
    }
  }
}
