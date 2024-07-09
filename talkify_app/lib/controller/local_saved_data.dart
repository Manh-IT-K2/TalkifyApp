import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalSavedData {
  static SharedPreferences? preferences;

  // initialize
  static Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  // save the userId
  static Future<void> saveUserId(String id) async {
    await preferences!.setString("userId", id);
  }

  // read the userId
  static String getUserId() {
    return preferences!.getString("userId") ?? "";
  }

  // save the userName
  static Future<void> saveUserName(String userName) async {
    await preferences!.setString("userName", userName);
  }

  // read the userName
  static String getUserName() {
    return preferences!.getString("userName") ?? "";
  }

  // save the user phone
  static Future<void> saveUserPhone(String phone) async {
    await preferences!.setString("phone", phone);
  }

  // read the user phone
  static String getUserPhone() {
    return preferences!.getString("phone") ?? "";
  }

  // save the user profile picture
  static Future<void> saveUserProfilePic(String profile) async {
    await preferences!.setString("profile", profile);
  }

  // read the user profile picture
  static String getUserProfilePic() {
    return preferences!.getString("profile") ?? "";
  }

  // clear all the saved data
  static clearAllData() {
    preferences!.clear();
    if (kDebugMode) {
      print("Cleared all data from local!");
    }
  }
}
