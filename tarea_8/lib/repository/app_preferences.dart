import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  AppPreferences._privateConstuctor();
  static final AppPreferences shared = AppPreferences._privateConstuctor();

  Future<String?> getStringPreference(String preference) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.getString(preference);
  }

  Future<void> setPreference(String preference, dynamic value) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setString(preference, value);
  }
}
