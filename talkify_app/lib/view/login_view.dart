import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:talkify_app/constant/color.dart';

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
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  //
  String countryCode = "+84";
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
                      "Enter your phone number to continute.",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      child: TextFormField(
                        key: formKey,
                        controller: phoneNumberController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.length != 10) {
                            return "Invalid phone number";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: CountryCodePicker(
                            onChanged: (value) {
                              if (kDebugMode) {
                                print(value.dialCode);
                              }
                              countryCode = value.dialCode!;
                            },
                            initialSelection: "VN",
                          ),
                          labelText: "Enter you phone number",
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
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("OTP Verification"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          labelText: "Enter the otp received",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12)
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(onPressed: (){
                                    if (formKey1.currentState!.validate()) {
                                      
                                    }
                                  }, child: const Text("Submit"))
                                ],
                              ),
                            );
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
