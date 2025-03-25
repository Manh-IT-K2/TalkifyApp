import 'dart:core';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:talkify_app/constants/color.dart';
import 'package:talkify_app/constants/text.dart';
import 'package:talkify_app/controllers/appwrite_controller.dart';
import 'package:talkify_app/providers/user_data_provider.dart';
import 'package:talkify_app/utils/theme_text.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  //
  final formKey = GlobalKey<FormState>();
  final formKey1 = GlobalKey<FormState>();

  //
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  void handleOtpSubmit(String userId, BuildContext context) {
    if (formKey1.currentState!.validate()) {
      loginWithOtp(otp: otpController.text, userId: userId).then((value) {
        if (value) {
          Provider.of<UserDataProvider>(context, listen: false)
              .setUserId(userId);

          Provider.of<UserDataProvider>(context, listen: false)
              .setUserEmail(emailController.text);

          Navigator.pushNamedAndRemoveUntil(
              context, "/update", (route) => false,
              arguments: {"title": "add"});
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Login failed!"),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: 100.h,
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: 60.h,
                child: Image.asset(
                  "assets/image/chat.png",
                  fit: BoxFit.none,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      txtTitleLog,
                      style:
                          PrimaryFont.titleBold().copyWith(color: Colors.black),
                    ),
                    Text(
                      txtSubTitleLog,
                      style: PrimaryFont.subTitleMedium()
                          .copyWith(color: Colors.black),
                    ),
                    SizedBox(
                      height: 5.w,
                    ),
                    Form(
                      key: formKey,
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: PrimaryFont.subTitleMedium(),
                        decoration: InputDecoration(
                          labelText: txtFormLog,
                          labelStyle: PrimaryFont.subTitleMedium()
                              .copyWith(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.w,
                    ),
                    SizedBox(
                      height: 12.w,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            createEmailSession(email: emailController.text)
                                .then((value) {
                              if (value != "login_error") {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                      txtTitleOtpLog,
                                      style: PrimaryFont.titleBold()
                                          .copyWith(color: Colors.black),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          txtSubTitleOtpLog,
                                          style: PrimaryFont.subTitleMedium()
                                              .copyWith(color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 5.w,
                                        ),
                                        Form(
                                          key: formKey1,
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: otpController,
                                            validator: (value) {
                                              if (value!.length != 6) {
                                                return "Invalid OTP";
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              labelText: txtFormOtpLog,
                                              labelStyle:
                                                  PrimaryFont.subTitleMedium()
                                                      .copyWith(
                                                          color: Colors.black),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          handleOtpSubmit(value, context);
                                        },
                                        child: Text(
                                          txtSubmitLog,
                                          style: PrimaryFont.subTitleMedium()
                                              .copyWith(color: kPrimaryColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Failed to send otp!",
                                      style: PrimaryFont.subTitleMedium(),
                                    ),
                                  ),
                                );
                              }
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            foregroundColor: Colors.white),
                        child: Text(
                          txtSendLog,
                          style: PrimaryFont.subTitleMedium(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
