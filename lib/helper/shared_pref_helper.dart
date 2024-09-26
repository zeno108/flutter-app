import 'package:shared_preferences/shared_preferences.dart';

class ShredPrefHelper {
  static SharedPreferences? pref;

  static Future<void> init() async {
    pref = await SharedPreferences.getInstance();
  }

  static void setData(String key, String value) {
    pref?.setString(key, value);
  }

  static String? getData(String key) {
    return pref?.getString(key);
  }
}
