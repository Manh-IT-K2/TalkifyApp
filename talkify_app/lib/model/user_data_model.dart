class UserDataModel {
  final String? name;
  final String email;
  final String userId;
  final String? profilePic;
  final String? deviceToken;
  final bool? isOnline;

  UserDataModel(
      {this.name,
      required this.email,
      required this.userId,
      this.profilePic,
      this.deviceToken,
      this.isOnline});

  // to convert document data to user data
  factory UserDataModel.toMap(Map<String, dynamic> map) {
    return UserDataModel(
        email: map["email"] ?? "",
        userId: map["userId"] ?? "",
        name: map["name"] ?? "",
        profilePic: map["profile_pic"] ?? "",
        deviceToken: map["device_token"] ?? "",
        isOnline: map["isOnline"] ?? ""
        );
  }
}
