import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:talkify_app/constants/color.dart';
import 'package:talkify_app/controllers/appwrite_controller.dart';
import 'package:talkify_app/providers/user_data_provider.dart';
import 'package:talkify_app/utils/theme_text.dart';
import 'package:sizer/sizer.dart';

class UpdateProfileView extends StatefulWidget {
  const UpdateProfileView({super.key});

  @override
  State<UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {

  //
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

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
            title: Text(
              datapassed["title"] == "edit" ? "Update" : "Add Details",
              style: PrimaryFont.titleBold(),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      _openFilePicker();
                    },
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          child: CircleAvatar(
                            radius: 30.w,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: _filePickerResult != null
                                ? Image(
                                    image: FileImage(
                                      File(
                                          _filePickerResult!.files.first.path!),
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
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(5.w),
                            decoration: const BoxDecoration(
                              color: kPrimaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: HugeIcon(
                              icon: HugeIcons.strokeRoundedEditUser02,
                              color: Colors.black,
                              size: 5.w,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 0.5),
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.circular(3.w)),
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.w),
                    child: Form(
                      key: _nameKey,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) return "Cannot be empty";
                          return null;
                        },
                        controller: _nameController,
                        style: PrimaryFont.subTitleMedium(),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter you name",
                            hintStyle: PrimaryFont.subTitleMedium()),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0.5),
                      color: kSecondaryColor,
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.w),
                    child: TextFormField(
                      controller: _emailController,
                      style: PrimaryFont.subTitleMedium(),
                      enabled: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "email",
                        hintStyle: PrimaryFont.subTitleMedium(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  SizedBox(
                    height: 7.h,
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
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          foregroundColor: Colors.white),
                      child: Text(
                        datapassed["title"] == "edit" ? "Update" : "Continue",
                        style: PrimaryFont.subTitleMedium(),
                      ),
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
