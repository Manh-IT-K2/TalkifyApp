import 'package:flutter/foundation.dart';
import 'package:talkify_app/controller/appwrite_controller.dart';
import 'package:talkify_app/model/chat_data_model.dart';
import 'package:talkify_app/model/message_model.dart';
import 'package:talkify_app/model/user_data_model.dart';

class ChatProvider extends ChangeNotifier {
  Map<String, List<ChatDataModel>> _chats = {};

  // get all users chats
  Map<String, List<ChatDataModel>> get getAllChats => _chats;

  // to load all current user chats
  void loadChats(String currentUser) async {
    Map<String, List<ChatDataModel>>? loadedChats = await currentUserChats(currentUser);

    if(loadedChats != null){
      _chats = loadedChats;
      _chats.forEach((key,value){
        value.sort((a,b) => a.message.timestamp.compareTo(b.message.timestamp));
      });
      notifyListeners();
    }
  }

  // add the chat message when user send a new message to someone alse 
  void addMessage(MessageModel message, String currentUser, List<UserDataModel> users){
    if(message.sender == currentUser){
      if(_chats[message.receiver] == null){
        _chats[message.receiver] = [];
      }

      _chats[message.receiver]!.add(ChatDataModel(message: message, users: users));
    } else {
      // the current user is receiver
      if(_chats[message.sender] == null){
        _chats[message.sender] = [];
      }

      _chats[message.receiver]!.add(ChatDataModel(message: message, users: users));
    }
    notifyListeners();
  }

  // delete message from the chats data
  void deleteMessage(MessageModel message, String currentUser, String? imageId) async {
    try {
      // user is delete the message 
      if (message.sender == currentUser) {
          _chats[message.receiver]!.removeWhere((element) => element.message == message);

          if(imageId != null){
            deleteImageFromBucket(oldImageId: imageId);
            if (kDebugMode) {
              print("Image delete from bucket");
            }
          }
          deleteCurrentUserChat(chatId: message.messageId!);
      } else {
        // current user is receiver
        _chats[message.sender]!.removeWhere((element) => element.message == message);
        if (kDebugMode) {
          print("Message deleted");
        }
      }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print("Error on message deletion");
      }
    }
  }
}