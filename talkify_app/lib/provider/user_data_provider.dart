import 'package:flutter/material.dart';
import 'package:talkify_app/controller/appwrite_controller.dart';
import 'package:talkify_app/controller/local_saved_data.dart';
import 'package:talkify_app/model/user_data_model.dart';

class UserDataProvider extends ChangeNotifier {
  String _userId = "";
  String _userName = "";
  String _userProfilePic = "";
  String _userEmail = "";
  String _userDeviceToken = "";

  String get getUserId => _userId;
  String get getUserName => _userName;
  String get getUserProfilePic => _userProfilePic;
  String get getUserEmail => _userEmail;
  String get getUserDeviceToken => _userDeviceToken;

// to load the data from the device
  void loadDataFromLocal() {
    _userId = LocalSavedData.getUserId();
    _userName = LocalSavedData.getUserName();
    _userProfilePic = LocalSavedData.getUserProfilePic();
    _userEmail = LocalSavedData.getUserEmail();

    notifyListeners();
  }

  // to load the data from out appwrite database user collection
  void loadUserData(String userId) async {
    UserDataModel? userData = await getUserDetail(userId: userId);
    if(userData != null){
      _userName = userData.name ?? "";
      _userProfilePic = userData.profilePic ?? "";
      notifyListeners();
    }
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
  void setUserEmail(String email) {
    _userEmail = email;
    LocalSavedData.saveUserEmail(email);
    notifyListeners();
  }

  // set user profile
  void setUserProfilePic(String profile) {
    _userProfilePic = profile;
    LocalSavedData.saveUserProfilePic(profile);
    notifyListeners();
  }

  // set device token
  void setDeviceToken(String token) {
    _userDeviceToken = token;
    notifyListeners();
  }

  // clear add values
  void clearAllProfile(){
  _userId = "";
  _userName = "";
  _userProfilePic = "";
  _userEmail = "";
  _userDeviceToken = "";
  notifyListeners();
  }
}
