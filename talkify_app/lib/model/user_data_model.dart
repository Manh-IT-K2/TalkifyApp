class UserDataModel {
  final String? name;
  final String phone;
  final String userId;
  final String? profilePic;
  final String? deviceToken;
  final bool? isOnline;

  UserDataModel(
      {this.name,
      required this.phone,
      required this.userId,
      this.profilePic,
      this.deviceToken,
      this.isOnline});

  // to convert document data to user data
  factory UserDataModel.toMap(Map<String, dynamic> map) {
    return UserDataModel(
        phone: map["phone_no"] ?? "",
        userId: map["userId"] ?? "",
        name: map["name"] ?? "",
        profilePic: map["profile_pic"] ?? "",
        deviceToken: map["device_token"] ?? "",
        isOnline: map["isOnline"] ?? ""
        );
  }
}
