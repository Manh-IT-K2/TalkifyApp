import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:talkify_app/main.dart';
import 'package:talkify_app/model/chat_data_model.dart';
import 'package:talkify_app/model/message_model.dart';
import 'package:talkify_app/model/user_data_model.dart';
import 'package:talkify_app/provider/chat_provider.dart';
import 'package:talkify_app/provider/user_data_provider.dart';

Client client = Client()
    .setEndpoint('https://cloud.appwrite.io/v1')
    .setProject('6680f2b1003440efdcfe')
    .setSelfSigned(
        status: true); // For self signed certificates, only use for development

const String db = "6680f3c70031774c27d1";
const String userCollection = "6680f3d20025bd400397";
const String chatCollection = "66b0f8540016c03e2df2";
const String storageBucket = "668d0d21002933fdfbd4";

Account account = Account(client);
final Databases databases = Databases(client);
final Storage storage = Storage(client);
final Realtime realtime = Realtime(client);

RealtimeSubscription? subscription;
// to subscribe to realtime changes
subcscribeToRealtime({required String userId}) {
  subscription = realtime.subscribe([
    "databases.$db.collections.$chatCollection.documents",
    "databases.$db.collections.$userCollection.documents"
  ]);

  if (kDebugMode) {
    print("Subscribing to realtime");
  }
  subscription!.stream.listen((data) {
    if (kDebugMode) {
      print("Some event happend");
    }
    // if (kDebugMode) {
    //   print(data.events);
    // }
    // if (kDebugMode) {
    //   print(data.payload);
    // }
    final firstItem = data.events[0].split(".");
    final eventType = firstItem[firstItem.length - 1];
    if (kDebugMode) {
      print("Event type is $eventType");
    }
    if (eventType == "create") {
      Provider.of<ChatProvider>(navigatorKey.currentState!.context,
              listen: false)
          .loadChats(userId);
    } else if (eventType == "update") {
      Provider.of<ChatProvider>(navigatorKey.currentState!.context,
              listen: false)
          .loadChats(userId);
    } else {
      if (eventType == "delete") {
        Provider.of<ChatProvider>(navigatorKey.currentState!.context,
                listen: false)
            .loadChats(userId);
      }
    }
  });
}

// save email number to database(while creating a new account)
Future saveEmailToDB({required String email, required String userId}) async {
  try {
    final response = await databases.createDocument(
        databaseId: db,
        collectionId: userCollection,
        documentId: userId,
        data: {"email": email, "userId": userId});
    if (kDebugMode) {
      print("success: $response");
    }
    return true;
  } on AppwriteException catch (e) {
    if (kDebugMode) {
      print("Cannot save to user databse: $e");
    }
    return false;
  }
}

// check whether phone number exits in database or not
Future<String> checkEmail({required String email}) async {
  try {
    final DocumentList matchUser = await databases.listDocuments(
        databaseId: db,
        collectionId: userCollection,
        queries: [Query.equal("email", email)]);
    if (matchUser.total > 0) {
      final Document user = matchUser.documents[0];
      if (user.data["email"] != null || user.data["email"] != "") {
        return user.data["userId"];
      } else {
        if (kDebugMode) {
          print("No user exist on DB");
        }
        return "user_not_exist";
      }
    } else {
      if (kDebugMode) {
        print("No user exist on DB");
      }
      return "user_not_exist";
    }
  } on AppwriteException catch (e) {
    if (kDebugMode) {
      print("Error on reading database: $e");
    }
    return "user_not_exist";
  }
}

// create  a phone session, send otp to the phone number
Future<String> createEmailSession({required String email}) async {
  try {
    final userId = await checkEmail(email: email);
    if (userId == "user_not_exist") {
      //creating a new account
      // final Token data = await account.createPhoneToken(userId: ID.unique(), phone: phone);
      final Token data =
          await account.createEmailToken(userId: ID.unique(), email: email);

      // save the new user to user collection
      saveEmailToDB(email: email, userId: data.userId);
      print("email: ${data.secret}");
      return data.userId;
    }
    // if user is an existing user
    else {
      // create phone token for existing user
      //final Token data = await account.createPhoneToken(userId: userId, phone: phone);
      final Token data =
          await account.createEmailToken(userId: userId, email: email);

      print("email1: ${data.secret}");
      return data.userId;
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error on cretae email session: $e");
    }
    return "login_error";
  }
}

// login with otp
Future<bool> loginWithOtp({required String otp, required String userId}) async {
  try {
    final Session session =
        await account.createSession(userId: userId, secret: otp);
    if (kDebugMode) {
      print(session.userId);
    }
    return true;
  } catch (e) {
    if (kDebugMode) {
      print("Err on login with otp: $e");
    }
    return false;
  }
}

// to check whether the session exits or not
Future<bool> checkSessions() async {
  try {
    final Session session = await account.getSession(sessionId: "current");
    if (kDebugMode) {
      print("Session exits ${session.$id}");
    }
    return true;
  } catch (e) {
    if (kDebugMode) {
      print("Session does not exits please login");
    }
    return false;
  }
}

// to logout the user and delete session
Future logoutUser() async {
  await account.deleteSession(sessionId: "current");
}

// load user data
Future<UserDataModel?> getUserDetail({required String userId}) async {
  try {
    final response = await databases.getDocument(
        databaseId: db, collectionId: userCollection, documentId: userId);
    if (kDebugMode) {
      print("Getting user data");
    }
    if (kDebugMode) {
      print(response.data);
    }
    Provider.of<UserDataProvider>(navigatorKey.currentContext!, listen: false)
        .setUserName(response.data["name"] ?? "");
    Provider.of<UserDataProvider>(navigatorKey.currentContext!, listen: false)
        .setUserProfilePic(response.data["profile_pic"] ?? "");
    return UserDataModel.toMap(response.data);
  } catch (e) {
    if (kDebugMode) {
      print("Error in getting user data: $e");
    }
    return null;
  }
}

// to update the user data
Future<bool> updateUserDetail(String pic,
    {required String userId, required String name}) async {
  try {
    final data = await databases.updateDocument(
        databaseId: db,
        collectionId: userCollection,
        documentId: userId,
        data: {"name": name, "profile_pic": pic});
    Provider.of<UserDataProvider>(navigatorKey.currentContext!, listen: false)
        .setUserName(name);
    Provider.of<UserDataProvider>(navigatorKey.currentContext!, listen: false)
        .setUserProfilePic(pic);
    if (kDebugMode) {
      print("Data userProfile update: $data");
    }
    return true;
  } catch (e) {
    if (kDebugMode) {
      print("Can not save userProfileUD to DB: $e");
    }
    return false;
  }
}

// upload and save image to storage bucket(create new image)
Future<String?> saveImageToBucket({required InputFile image}) async {
  try {
    final response = await storage.createFile(
        bucketId: storageBucket, fileId: ID.unique(), file: image);
    if (kDebugMode) {
      print("The response after save to bucket $response");
    }
    return response.$id;
  } catch (e) {
    if (kDebugMode) {
      print("Error on saving image to bucket: $e");
    }
    return null;
  }
}

// update an image in bucget : first delete then create new
Future<String?> updateImageOnBucket(
    {required String oldImageId, required InputFile image}) async {
  try {
    // to delete the old image
    deleteImageFromBucket(oldImageId: oldImageId);

    // create a new image
    final newImage = saveImageToBucket(image: image);
    return newImage;
  } catch (e) {
    if (kDebugMode) {
      print("Cannot update / delete image: $e");
    }
    return null;
  }
}

// to only delete the image from the storage bucget
Future<bool> deleteImageFromBucket({required String oldImageId}) async {
  try {
    // to delete the old image
    await storage.deleteFile(bucketId: storageBucket, fileId: oldImageId);
    return true;
  } catch (e) {
    if (kDebugMode) {
      print("Cannot update / delete image: $e");
    }
    return false;
  }
}

// to search all the users from the database
Future<DocumentList?> searchUsers(
    {required String searchItem, required String userId}) async {
  try {
    final DocumentList users = await databases.listDocuments(
        databaseId: db,
        collectionId: userCollection,
        queries: [
          Query.search("email", searchItem),
          Query.notEqual("userId", userId)
        ]);
    if (kDebugMode) {
      print("Total match users ${users.total}");
    }
    return users;
  } catch (e) {
    if (kDebugMode) {
      print("Error on search users: $e");
    }
    return null;
  }
}

// create a new chat and save to database
Future createNewChat(
    {required String message,
    required String senderId,
    required String receiverId,
    required bool isImage}) async {
  try {
    final msg = await databases.createDocument(
        databaseId: db,
        collectionId: chatCollection,
        documentId: ID.unique(),
        data: {
          "message": message,
          "senderId": senderId,
          "receiverId": receiverId,
          "timestamp": DateTime.now().toIso8601String(),
          "isSeenByRecevier": false,
          "isImage": isImage,
          "users": [senderId, receiverId]
        });
    if (kDebugMode) {
      print("Message send");
    }
    return true;
  } catch (e) {
    if (kDebugMode) {
      print("Failed to send message :$e");
    }
    return false;
  }
}

// to list all the chats belonging to the current user
Future<Map<String, List<ChatDataModel>>?> currentUserChats(
    String userId) async {
  try {
    var results = await databases
        .listDocuments(databaseId: db, collectionId: chatCollection, queries: [
      Query.or(
          [Query.equal("senderId", userId), Query.equal("receiverId", userId)]),
      Query.orderDesc("timestamp")
    ]);
    final DocumentList chatDocuments = results;
    if (kDebugMode) {
      print(
          "Chat documents ${chatDocuments.total} and documents ${chatDocuments.documents.length}");
    }

    Map<String, List<ChatDataModel>> chats = {};

    if (chatDocuments.documents.isNotEmpty) {
      for (var i = 0; i < chatDocuments.documents.length; i++) {
        var doc = chatDocuments.documents[i];
        String sender = doc.data["senderId"];
        String receiver = doc.data["receiverId"];

        MessageModel message = MessageModel.fromMap(doc.data);

        List<UserDataModel> users = [];
        for (var user in doc.data["users"]) {
          users.add(UserDataModel.toMap(user));
        }

        String key = (sender == userId) ? receiver : sender;
        if (chats[key] == null) {
          chats[key] = [];
        }
        chats[key]!.add(ChatDataModel(message: message, users: users));
      }
    }
    return chats;
  } catch (e) {
    if (kDebugMode) {
      print("Error in reading current user chats : $e");
    }
    return null;
  }
}

// to delete the chat from database chat collection
Future deleteCurrentUserChat({required String chatId}) async {
  try {
    await databases.deleteDocument(
        databaseId: db, collectionId: chatCollection, documentId: chatId);
  } catch (e) {
    if (kDebugMode) {
      print("Error on deleting chat mesage : $e");
    }
  }
}

// edit our chat message and update to database
Future editChat({required String chatId, required String message}) async {
  try {
    await databases.updateDocument(
        databaseId: db,
        collectionId: chatCollection,
        documentId: chatId,
        data: {"message": message});
    if (kDebugMode) {
      print("Message update");
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error on editing message : $e");
    }
  }
}
