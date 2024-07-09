import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/foundation.dart';
import 'package:talkify_app/model/user_data_model.dart';

Client client = Client()
    .setEndpoint('https://cloud.appwrite.io/v1')
    .setProject('6680f2b1003440efdcfe')
    .setSelfSigned(
        status: true); // For self signed certificates, only use for development

const String db = "6680f3c70031774c27d1";
const String userCollection = "6680f3d20025bd400397";
const String storageBucket = "668d0d21002933fdfbd4";

Account account = Account(client);
final Databases databases = Databases(client);
final Storage storage = Storage(client);

// save phone number to database(while creating a new account)

Future savePhoneToDB({required String phoneNo, required String userId}) async {
  try {
    final response = await databases.createDocument(
        databaseId: db,
        collectionId: userCollection,
        documentId: userId,
        data: {"phone_no": phoneNo, "userId": userId});
    if (kDebugMode) {
      print(response);
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
Future<String> checkPhoneNumber({required String phoneNo}) async {
  try {
    final DocumentList matchUser = await databases.listDocuments(
        databaseId: db,
        collectionId: userCollection,
        queries: [Query.equal("phone_no", phoneNo)]);
    if (matchUser.total > 0) {
      final Document user = matchUser.documents[0];
      if (user.data["phone_no"] != null || user.data["phone_no"] != "") {
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

// create  a phone secction, send otp to the phone number
Future<String> createPhoneSecction({required String phone}) async {
  try {
    final userId = await checkPhoneNumber(phoneNo: phone);
    if (userId == "user_not_exist") {
      //creating a new account
      final Token data =
          await account.createPhoneToken(userId: ID.unique(), phone: phone);

      // save the new user to user collection
      savePhoneToDB(phoneNo: phone, userId: data.userId);
      print("phone: ${data.secret}");
      return data.userId;
    }
    // if user is an existing user
    else {
      // create phone token for existing user
      final Token data =
          await account.createPhoneToken(userId: userId, phone: phone);
      print("phone2: ${data.secret}");
      return data.userId;
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error on cretae phone session: $e");
    }
    return "login_error";
  }
}

// login with otp
Future<bool> loginWithOtp({required String otp, required String userId}) async {
  try {
    final Session session =
        await account.updatePhoneSession(userId: userId, secret: otp);
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
    return UserDataModel.toMap(response.data);
  } catch (e) {
    if (kDebugMode) {
      print("Error in getting user data: $e");
    }
    return null;
  }
}

// upload and save image to storage bucket(create new image)
Future<String?> saveImageToBucket({required InputFile image}) async {
  try {
    final response = await storage.createFile(bucketId: storageBucket, fileId: ID.unique(), file: image);
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