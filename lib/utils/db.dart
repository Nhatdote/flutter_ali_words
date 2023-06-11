import 'package:shared_preferences/shared_preferences.dart';

class DB {
  static const perPage = 'per_page';
  static const favorites = 'favorites';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception(
          'SharedPreferences has not been initialized. Call init() before accessing prefs.');
    }
    return _prefs!;
  }
}