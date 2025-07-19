import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmanager/networks/network_requester.dart';
import 'package:taskmanager/screens/email_screen.dart';
import 'package:taskmanager/screens/main%20screen/main_screen.dart';
import 'package:taskmanager/screens/registration_screen.dart';
import 'package:taskmanager/utils/userdata.dart';
import 'package:taskmanager/widgets/backgroundimage.dart';
import 'package:taskmanager/widgets/button.dart';
import 'package:taskmanager/widgets/myrow.dart';
import 'package:taskmanager/widgets/textfield.dart';
import 'package:taskmanager/widgets/textstyle.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formlogin = GlobalKey<FormState>();

  final TextEditingController emailTEController = TextEditingController();
  final TextEditingController passwordTEController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundImage(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formlogin,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  Text("Get Started With", style: mainText),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: emailTEController,
                    decoration: textFieldDecoration("User Name"),
                    validator: (String? text) {
                      if (text?.isEmpty ?? true) {
                        return "Enter your email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: passwordTEController,
                    obscureText: true,
                    decoration: textFieldDecoration("Password"),
                    validator: (String? text) {
                      if (text?.isEmpty ?? true) {
                        return "Enter your password";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  MyButton(
                    onTap: () async {
                      if (_formlogin.currentState!.validate()) {
                        final result = await NetworkRequester().postRequest(
                          "https://task.teamrabbil.com/api/v1/login",
                          {
                            "email": emailTEController.text,
                            "password": passwordTEController.text,
                          },
                        );

                        if (result != null && result['status'] == 'success') {
                          final sharedPrefs =
                              await SharedPreferences.getInstance();
                          // Store data in UserData
                          UserData.token = result['token'];
                          UserData.email = result['data']['email'];
                          UserData.firstName = result['data']['firstName'];
                          UserData.lastName = result['data']['lastName'];
                          UserData.phone = result['data']['mobile'];
                          UserData.photo = result['data']['photo'];

                          sharedPrefs.setString(
                            "email",
                            result['data']['email'],
                          );
                          sharedPrefs.setString(
                            "firstName",
                            result['data']['firstName'],
                          );
                          sharedPrefs.setString(
                            "lastName",
                            result['data']['lastName'],
                          );
                          sharedPrefs.setString(
                            "photo",
                            result['data']['photo'],
                          );
                          await sharedPrefs.setString(
                            "phone",
                            result['data']['mobile'],
                          );
                          sharedPrefs.setString("token", result['token']);

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskDashboardScreen(),
                            ),
                            (route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Login Failed")),
                          );
                        }
                      }
                    },
                  ),

                  const SizedBox(height: 50),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EmailScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "forgot password?",
                        style: TextStyle(
                          color: Color.fromARGB(255, 148, 146, 147),
                          fontFamily: "regular",
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  MyRow(
                    text: "Don't have acoount?",
                    textButton: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegistrationScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign Up",
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
