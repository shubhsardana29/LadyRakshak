import 'package:shared_preferences/shared_preferences.dart';

class MysharedPref {
  static SharedPreferences? _preferences;
  static const String key = 'usertype';

   static Future<SharedPreferences> init() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences!;
  }

  static Future<void> saveUserType(String type) async {
    await _preferences!.setString(key, type);
  }

  static Future<String> getUserType() async {
    return _preferences!.getString(key) ?? '';
  }
}