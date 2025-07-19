import 'package:flutter/material.dart';
import 'package:taskmanager/networks/network_requester.dart';
import 'package:taskmanager/screens/login_screen.dart';
import 'package:taskmanager/widgets/backgroundimage.dart';
import 'package:taskmanager/widgets/button.dart';
import 'package:taskmanager/widgets/myrow.dart';
import 'package:taskmanager/widgets/textfield.dart';
import 'package:taskmanager/widgets/textstyle.dart';

class SetpassworldScreen extends StatefulWidget {
  final String email;
  final String otp;

  const SetpassworldScreen({super.key, required this.email, required this.otp});

  @override
  State<SetpassworldScreen> createState() => _SetpassworldScreenState();
}

class _SetpassworldScreenState extends State<SetpassworldScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController =
      TextEditingController();

  bool _isLoading = false;

  void _resetPassword() async {
    final password = _passwordController.text.trim();
    final retypePassword = _retypePasswordController.text.trim();

    if (password != retypePassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Passwords do not match")));
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password must be at least 7 characters")),
      );
      return;
    }

    setState(() => _isLoading = true);

    final response = await NetworkRequester().postRequest(
      "https://task.teamrabbil.com/api/v1/RecoverResetPass",
      {"email": widget.email, "OTP": widget.otp, "password": password},
    );

    setState(() => _isLoading = false);

    if (response['status'] == 'success') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Password updated successfully")));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to update password")));
    }
  }

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
              Text("Set Password", style: mainText),
              const SizedBox(height: 10),
              Text(
                "Minimum password length 6 characters with letter and number combination",
                style: sub1Text,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: textFieldDecoration("New Password"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _retypePasswordController,
                obscureText: true,
                decoration: textFieldDecoration("Re-type Password"),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : MyButton(onTap: _resetPassword, text: "Confirm"),
              const SizedBox(height: 40),
              MyRow(
                text: "Have an account?",
                textButton: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
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
    );
  }
}
