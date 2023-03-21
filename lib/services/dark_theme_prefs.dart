// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

class DarkThemePrefs {
  static const themeStatus = 'THEMESTATUS';

  // ignore: always_declare_return_types, avoid_positional_boolean_parameters, inference_failure_on_function_return_type, type_annotate_public_apis
  setDarkTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(themeStatus, value);
  }

  Future<bool> getTheme({required bool defaultVal}) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(themeStatus)) {
      return prefs.getBool(themeStatus) ?? defaultVal;
    } else {
      return defaultVal;
    }
  }
}
