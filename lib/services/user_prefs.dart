import 'package:shared_preferences/shared_preferences.dart';

/// Track That Money
/// lib/services/user_prefs.dart

class UserPrefs {
  static const _kUserName = 'ttm.user_name';

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kUserName);
  }

  static Future<void> setUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUserName, name);
  }
}
