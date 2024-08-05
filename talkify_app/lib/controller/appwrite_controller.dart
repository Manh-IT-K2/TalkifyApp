import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:talkify_app/main.dart';
import 'package:talkify_app/model/user_data_model.dart';
import 'package:talkify_app/provider/user_data_provider.dart';

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
      final Token data = await account.createEmailToken(userId: ID.unique(), email: email);

      // save the new user to user collection
      saveEmailToDB(email: email, userId: data.userId);
      print("email: ${data.secret}");
      return data.userId;
    }
    // if user is an existing user
    else {
      // create phone token for existing user
      //final Token data = await account.createPhoneToken(userId: userId, phone: phone);
      final Token data = await account.createEmailToken(userId: userId, email: email);
            
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
    final Session session = await account.createSession(userId: userId, secret: otp);
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
Future<DocumentList?> searchUsers({required String searchItem, required String userId}) async {
  try {
    final DocumentList users = await databases.listDocuments(databaseId: db, collectionId: userCollection, queries: [
      Query.search("email", searchItem),
      Query.notEqual("email", userId)
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