import 'package:flutter/material.dart';
import 'package:taskmanager/networks/network_requester.dart';
import 'package:taskmanager/screens/login_screen.dart';
import 'package:taskmanager/screens/pinverification.dart';
import 'package:taskmanager/widgets/backgroundimage.dart';
import 'package:taskmanager/widgets/button.dart';
import 'package:taskmanager/widgets/myrow.dart';
import 'package:taskmanager/widgets/textfield.dart';
import 'package:taskmanager/widgets/textstyle.dart';

class EmailScreen extends StatelessWidget {
  EmailScreen({super.key});

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundImage(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Your Email Address", style: mainText),
              const SizedBox(height: 15),
              Text(
                "A 6 digit verification pin will send to your email address",
                style: sub1Text,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _emailController,
                decoration: textFieldDecoration("Email"),
              ),

              const SizedBox(height: 16),

              MyButton(
                onTap: () async {
                  final response = await NetworkRequester().getRequest(
                    "https://task.teamrabbil.com/api/v1/RecoverVerifyEmail/${_emailController.text.trim()}",
                  );

                  if (response['status'] == 'success') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Pinverification(
                          email: _emailController.text.trim(),
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Email not found")));
                  }
                },
                text: "Verify",
              ),

              const SizedBox(height: 50),

              MyRow(
                text: "Have account?",
                textButton: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: const Text(
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
    );
  }
}
