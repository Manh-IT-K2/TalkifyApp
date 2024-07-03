import 'package:flutter/material.dart';
import 'package:talkify_app/controller/local_saved_data.dart';

class UserDataProvider extends ChangeNotifier {
  String _userId = "";
  String _userName = "";
  String _userProfilePic = "";
  String _userPhoneNumber = "";
  String _userDeviceToken = "";

  String get getUserId => _userId;
  String get getUserName => _userName;
  String get getUserProfilePic => _userProfilePic;
  String get getUserPhoneNumber => _userPhoneNumber;
  String get getUserDeviceToken => _userDeviceToken;

// to load the data from the device
  void loadDataFromLocal() {
    _userId = LocalSavedData.getUserId();
    _userName = LocalSavedData.getUserName();
    _userProfilePic = LocalSavedData.getUserProfile();
    _userPhoneNumber = LocalSavedData.getUserPhone();

    notifyListeners();
  }

  // set user id
  void setUserId(String id) {
    _userId = id;
    LocalSavedData.saveUserId(id);
    notifyListeners();
  }

  // set user name
  void setUserName(String userName) {
    _userName = userName;
    LocalSavedData.saveUserName(userName);
    notifyListeners();
  }

  // set user phone
  void setUserPhoneNumber(String phone) {
    _userPhoneNumber = phone;
    LocalSavedData.saveUserPhone(phone);
    notifyListeners();
  }

  // set user profile
  void setUserProfile(String profile) {
    _userProfilePic = profile;
    LocalSavedData.saveUserProfile(profile);
    notifyListeners();
  }

  // set device token 
  void setDeviceToken(String token){
    _userDeviceToken = token;
    notifyListeners();
  }
}
