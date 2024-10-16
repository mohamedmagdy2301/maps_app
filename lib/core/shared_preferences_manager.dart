import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static late SharedPreferences _sharedPreferences;

  /// Initializes the SharedPreferences instance
  static Future<void> sharedPreferencesInitialize() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  /// Stores data of various types in SharedPreferences
  static Future<bool> setData(
      {required String key, required dynamic value}) async {
    if (value is String) {
      await _sharedPreferences.setString(key, value);
      return true;
    } else if (value is int) {
      await _sharedPreferences.setInt(key, value);
      return true;
    } else if (value is bool) {
      await _sharedPreferences.setBool(key, value);
      return true;
    } else if (value is double) {
      await _sharedPreferences.setDouble(key, value);
      return true;
    } else if (value is List<String>) {
      await _sharedPreferences.setStringList(key, value);
      return true;
    } else if (value is List<List<dynamic>>) {
      String jsonString = json.encode(value);
      await _sharedPreferences.setString(key, jsonString);
      return true;
    }
    return false;
  }

  /// Retrieves data from SharedPreferences based on the key
  static dynamic getData({required String key}) {
    String? jsonString = _sharedPreferences.getString(key);
    if (jsonString != null) {
      try {
        List<dynamic> jsonData = json.decode(jsonString);
        return jsonData
            .map<List<dynamic>>((e) => List<dynamic>.from(e))
            .toList();
      } catch (e) {
        return jsonString; // If not a JSON list, return as a simple string
      }
    }
    return _sharedPreferences.get(key);
  }

  /// Removes a specific key-value pair from SharedPreferences
  static Future<bool> removeData({required String key}) async {
    await _sharedPreferences.remove(key);
    return true;
  }

  /// Clears all data from SharedPreferences
  static Future<bool> clearAllData() async {
    await _sharedPreferences.clear();
    return true;
  }
}
