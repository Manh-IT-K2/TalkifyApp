import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/foundation.dart';

Client client = Client()
    .setEndpoint('https://cloud.appwrite.io/v1')
    .setProject('6680f2b1003440efdcfe')
    .setSelfSigned(
        status: true); // For self signed certificates, only use for development

const String db = "6680f3c70031774c27d1";
const String userCollection = "6680f3d20025bd400397";

Account account = Account(client);
final Databases databases = Databases(client);

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
        return "User not exist";
      }
    } else {
      if (kDebugMode) {
        print("No user exist on DB");
      }
      return "User not exist";
    }
  } on AppwriteException catch (e) {
    if (kDebugMode) {
      print("Error on reading database: $e");
    }
    return "User not exist";
  }
}


// create  a phone secction, send otp to the phone number
Future<String> createPhoneSecction({required String phone}) async {
  try {
    final userId = await checkPhoneNumber(phoneNo: phone);
    if (userId == "User not exist") {
      //creating a new account
      final Token data = await account.createPhoneToken(userId: userId, phone: phone);  

      // save the new user to user collection
      savePhoneToDB(phoneNo: phone, userId: data.userId);
      return data.userId;
    }
    // if user is an existing user
    else{
      // create phone token for existing user
      final Token data = await account.createPhoneToken(userId: userId, phone: phone);
      return data.userId;
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error on cretae phone session: $e");
    }
    return "Login error";
  }
}
