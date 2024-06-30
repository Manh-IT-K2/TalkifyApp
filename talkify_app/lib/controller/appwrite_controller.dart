import 'package:appwrite/appwrite.dart';

Client client = Client()
    .setEndpoint('https://cloud.appwrite.io/v1')
    .setProject('6680f2b1003440efdcfe')
    .setSelfSigned(
        status: true); // For self signed certificates, only use for development