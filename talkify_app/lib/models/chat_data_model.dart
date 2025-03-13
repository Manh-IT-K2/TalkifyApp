import 'package:talkify_app/models/message_model.dart';
import 'package:talkify_app/models/user_data_model.dart';

class ChatDataModel {
  final MessageModel message;
  final List<UserDataModel> users;

  ChatDataModel({
    required this.message,
    required this.users
  });
}