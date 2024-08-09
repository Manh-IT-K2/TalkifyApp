import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkify_app/constant/color.dart';
import 'package:talkify_app/controller/appwrite_controller.dart';
import 'package:talkify_app/provider/user_data_provider.dart';

class UpdateProfileView extends StatefulWidget {
  const UpdateProfileView({super.key});

  @override
  State<UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  //
  FilePickerResult? _filePickerResult;
  late String? imageId = "";
  late String? userId = "";

  //
  final _nameKey = GlobalKey<FormState>();

  @override
  void initState() {
    // try to load the data from local database
    Future.delayed(Duration.zero, () {
      userId = Provider.of<UserDataProvider>(context, listen: false).getUserId;
      Provider.of<UserDataProvider>(context, listen: false)
          .loadUserData(userId!);
      imageId = Provider.of<UserDataProvider>(context, listen: false)
          .getUserProfilePic;
    });
    super.initState();
  }

  // to open file picker
  void _openFilePicker() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    setState(() {
      _filePickerResult = result;
    });
  }

  // upload user profile image and save it to bucket and database
  Future uploadProfileImage() async {
    try {
      if (_filePickerResult != null && _filePickerResult!.files.isNotEmpty) {
        PlatformFile file = _filePickerResult!.files.first;
        final fileByes = await File(file.path!).readAsBytes();
        final inputFile =
            InputFile.fromBytes(bytes: fileByes, filename: file.name);

        // if image already exist for the user profile or not
        if (imageId != null && userId != "") {
          //
          await updateImageOnBucket(oldImageId: imageId!, image: inputFile)
              .then((value) {
            if (value != null) {
              imageId = value;
            }
          });
        }
        // create new image and upload to bucket
        else {
          await saveImageToBucket(image: inputFile).then((value) {
            if (value != null) {
              imageId = value;
            }
          });
        }
      } else {
        if (kDebugMode) {
          print("Something went wrong!");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error on uploading image: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> datapassed =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Consumer<UserDataProvider>(
      builder: (context, value, child) {
        _nameController.text = value.getUserName;
        _emailController.text = value.getUserEmail;
        return Scaffold(
          appBar: AppBar(
            title:
                Text(datapassed["title"] == "edit" ? "Update" : "Add Details"),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      _openFilePicker();
                    },
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 120,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: _filePickerResult != null
                              ? Image(
                                  image: FileImage(
                                    File(_filePickerResult!.files.first.path!),
                                  ),
                                ).image
                              : value.getUserProfilePic != ""
                                  ? CachedNetworkImageProvider(
                                      "https://cloud.appwrite.io/v1/storage/buckets/668d0d21002933fdfbd4/files/${value.getUserProfilePic}/view?project=6680f2b1003440efdcfe&mode=admin")
                                  : const Image(
                                      image:
                                          AssetImage("assets/image/user.png"),
                                    ).image,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Icon(
                              Icons.edit_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.all(6),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Form(
                      key: _nameKey,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) return "Cannot be empty";
                          return null;
                        },
                        controller: _nameController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter you name"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.all(6),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: TextFormField(
                      controller: _emailController,
                      enabled: false,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: "email"),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_nameKey.currentState!.validate()) {
                          // upload the image if file is picked
                          if (_filePickerResult != null) {
                            await uploadProfileImage();
                          }

                          // save the data to database user colection
                          await updateUserDetail(imageId ?? "",
                              userId: userId!, name: _nameController.text);

                          // navigate the user to the home route
                          Navigator.pushNamedAndRemoveUntil(
                              context, "/home", (route) => false);
                        }
                      },
                      child: Text(datapassed["title"] == "edit"
                          ? "Update"
                          : "Continue"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          foregroundColor: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
