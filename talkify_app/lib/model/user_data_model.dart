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
}
