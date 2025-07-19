import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmanager/networks/api_link.dart';
import 'package:taskmanager/networks/network_requester.dart';
import 'package:taskmanager/utils/userdata.dart';
import 'package:taskmanager/widgets/appbar.dart';
import 'package:taskmanager/widgets/backgroundimage.dart';
import 'package:taskmanager/widgets/button.dart';
import 'package:taskmanager/widgets/textfield.dart';
import 'package:taskmanager/widgets/textstyle.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController emailTEController = TextEditingController();
  final TextEditingController firstTEController = TextEditingController();
  final TextEditingController lastTEController = TextEditingController();
  final TextEditingController phoneTEController = TextEditingController();
  final TextEditingController passwordTEController = TextEditingController();

  final _formUpdate = GlobalKey<FormState>();

  XFile? photoFile;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    emailTEController.text = UserData.email ?? prefs.getString('email') ?? '';
    firstTEController.text =
        UserData.firstName ?? prefs.getString('firstName') ?? '';
    lastTEController.text =
        UserData.lastName ?? prefs.getString('lastName') ?? '';
    phoneTEController.text = UserData.phone ?? prefs.getString('phone') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBarWidget(isTappable: false),
      body: BackgroundImage(
        child: Form(
          key: _formUpdate,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Update Profile", style: mainText),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () async {
                      final ImagePicker imagePicker = ImagePicker();
                      final result = await imagePicker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (result != null) {
                        photoFile = result;
                        setState(() {});
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(color: Color(0XFF666666)),
                            child: Text(
                              "Photo",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),

                          Visibility(
                            visible: photoFile != null,
                            replacement: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "Select a photo",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: "reguler",
                                ),
                              ),
                            ),
                            child: Image.file(
                              File(photoFile?.path ?? ''),
                              height: 25,
                              width: 25,
                            ),
                          ),
                          Expanded(
                            child: Text(photoFile?.name ?? '', maxLines: 3),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    readOnly: true,
                    controller: emailTEController,
                    decoration: textFieldDecoration("Email"),
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return "Enter your mail";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: firstTEController,
                    decoration: textFieldDecoration("First Name"),
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return "Enter your First Name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: lastTEController,
                    decoration: textFieldDecoration("Last Name"),
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return "Enter your Last Name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    readOnly: true,
                    controller: phoneTEController,
                    decoration: textFieldDecoration("Mobile"),
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return "Enter your phone";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: passwordTEController,
                    obscureText: true,
                    decoration: textFieldDecoration("Password"),
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return "Enter your mail";
                      } else if (value!.length < 6) {
                        return "Enter Password atleast 7 Letter";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  MyButton(
                    onTap: () async {
                      if (_formUpdate.currentState!.validate()) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) =>
                              const Center(child: CircularProgressIndicator()),
                        );

                        Map<String, String> body = {
                          "firstName": firstTEController.text.trim(),
                          "lastName": lastTEController.text.trim(),
                        };

                        if (passwordTEController.text.trim().isNotEmpty) {
                          body["password"] = passwordTEController.text.trim();
                        }

                        final result = await NetworkRequester()
                            .multipartRequest(
                              Urls.updateProfile,
                              body,
                              photoFile?.path,
                            );

                        if (mounted)
                          Navigator.pop(context); // close progress dialog

                        Logger().e('Update result: $result');

                        if (result != null && result['status'] == 'success') {
                          await UserData.updateProfileData(
                            email: result['data']['email'],
                            firstName: result['data']['firstName'],
                            lastName: result['data']['lastName'],
                            phone: result['data']['mobile'],
                            photo: result['data']['photo'],
                          );

                          firstTEController.text = UserData.firstName ?? '';
                          lastTEController.text = UserData.lastName ?? '';
                          setState(() {});

                          // Show snackbar first
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Profile updated successfully"),
                            ),
                          );

                          // Delay a bit so user sees the snackbar
                          await Future.delayed(
                            const Duration(milliseconds: 500),
                          );

                          Navigator.pop(context, true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Failed to update profile"),
                            ),
                          );
                        }
                      }
                    },

                    text: "Update",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
