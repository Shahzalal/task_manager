import 'package:flutter/material.dart';
import 'package:taskmanager/networks/network_requester.dart';
import 'package:taskmanager/screens/login_screen.dart';
import 'package:taskmanager/widgets/backgroundimage.dart';
import 'package:taskmanager/widgets/button.dart';
import 'package:taskmanager/widgets/myrow.dart';
import 'package:taskmanager/widgets/textfield.dart';
import 'package:taskmanager/widgets/textstyle.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _fromRegistrtion = GlobalKey<FormState>();

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _phoneTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundImage(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _fromRegistrtion,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  Text("Join With Us", style: mainText),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailTEController,
                    decoration: textFieldDecoration("Email"),
                    validator: (String? text) {
                      if (text?.isEmpty ?? true) {
                        return "Enter your email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _firstNameTEController,
                    decoration: textFieldDecoration("First Name"),
                    validator: (String? text) {
                      if (text?.isEmpty ?? true) {
                        return "Enter your first name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _lastNameTEController,
                    decoration: textFieldDecoration("last Name"),
                    validator: (String? text) {
                      if (text?.isEmpty ?? true) {
                        return "Enter your last name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneTEController,
                    decoration: textFieldDecoration("Mobile"),
                    validator: (String? text) {
                      if (text?.isEmpty ?? true) {
                        return "Enter your mobile";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordTEController,
                    decoration: textFieldDecoration("Password"),
                    validator: (String? text) {
                      if (text?.isEmpty ?? true) {
                        return "Enter your password";
                      } else if (text!.length < 6) {
                        return "Enter password minimum 6 letter";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  MyButton(
                    onTap: () async {
                      if (_fromRegistrtion.currentState!.validate()) {
                        final result = await NetworkRequester().postRequest(
                          "https://task.teamrabbil.com/api/v1/registration",
                          {
                            "email": _emailTEController.text,
                            "firstName": _firstNameTEController.text,
                            "lastName": _lastNameTEController.text,
                            "mobile": _phoneTEController.text,
                            "password": _passwordTEController.text,
                            "photo": "",
                          },
                        );
                        if (result['status'] == 'success') {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Registration Successful"),
                              ),
                            );
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Registration Failed")),
                            );
                          }
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 50),

                  MyRow(
                    text: "Have an acoount?",
                    textButton: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          color: Color(0xFFA1045A),
                          fontFamily: "bold",
                          fontSize: 14,
                        ),
                      ),
                    ),
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
