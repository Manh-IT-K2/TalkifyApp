import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkify_app/constant/color.dart';
import 'package:talkify_app/controller/appwrite_controller.dart';
import 'package:talkify_app/provider/user_data_provider.dart';

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
              context, "/updateProfile", (route) => false,
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
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: Image.asset(
                  "assets/image/chat.png",
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcom to Talkify",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                    ),
                    const Text(
                      "Enter your email to continute.",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: formKey,
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          
                        },
                        decoration: InputDecoration(
                    
                          labelText: "Enter you email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            createEmailSession(
                                    email: emailController.text)
                                .then((value) {
                              if (value != "login_error") {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("OTP Verification"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Enter 6 digit OTP"),
                                        const SizedBox(
                                          height: 12,
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
                                              labelText:
                                                  "Enter the otp received",
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
                                        child: const Text("Submit"),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Failed to send otp!"),
                                  ),
                                );
                              }
                            });
                          }
                        },
                        child: Text("Send OTP"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            foregroundColor: Colors.white),
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
