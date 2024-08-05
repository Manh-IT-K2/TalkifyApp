import 'package:talkify_app/model/message_model.dart';
import 'package:talkify_app/model/user_data_model.dart';

class ChatDataModel {
  final MessageModel message;
  final List<UserDataModel> users;

  ChatDataModel({
    required this.message,
    required this.users
  });
}