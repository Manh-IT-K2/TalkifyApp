import 'package:flutter/material.dart';
import 'package:talkify_app/constant/color.dart';

class UpdateProfileView extends StatefulWidget {
  const UpdateProfileView({super.key});

  @override
  State<UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update"),
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
              Stack(
                children: [
                  CircleAvatar(
                    radius: 120,
                    backgroundImage: const Image(
                      image: AssetImage("assets/image/user.png"),
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
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(6),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: TextFormField(
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: "Enter you name"),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: TextFormField(
                  enabled: false,
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: "Phone number"),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text("Update"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor, foregroundColor: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
