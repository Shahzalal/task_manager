import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:taskmanager/networks/network_requester.dart';
import 'package:taskmanager/screens/login_screen.dart';
import 'package:taskmanager/screens/setpassworld_screen.dart';
import 'package:taskmanager/widgets/backgroundimage.dart';
import 'package:taskmanager/widgets/button.dart';
import 'package:taskmanager/widgets/myrow.dart';
import 'package:taskmanager/widgets/textstyle.dart';

class Pinverification extends StatefulWidget {
  const Pinverification({super.key, required this.email});

  final String email;

  @override
  State<Pinverification> createState() => _PinverificationState();
}

class _PinverificationState extends State<Pinverification> {
  final TextEditingController _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Color(0xFFA1045A),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return Scaffold(
      body: BackgroundImage(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 200),
                Text("Pin Verification", style: mainText),
                const SizedBox(height: 15),
                Text(
                  "A 6 digit verification pin will send to your email address",
                  style: sub1Text,
                ),
                const SizedBox(height: 25),

                // Pinput widget
                Pinput(
                  length: 6,
                  controller: _pinController,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      border: Border.all(color: Color(0xFFA1045A)),
                    ),
                  ),
                  submittedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  onCompleted: (pin) {},
                ),

                const SizedBox(height: 24),

                // MyButton
                MyButton(
                  text: "Verify",
                  onTap: () async {
                    final pin = _pinController.text.trim();
                    final response = await NetworkRequester().getRequest(
                      "https://task.teamrabbil.com/api/v1/RecoverVerifyOTP/${widget.email}/$pin",
                    );

                    if (response['status'] == 'success') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SetpassworldScreen(email: widget.email, otp: pin),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Invalid or expired OTP")),
                      );
                    }
                  },
                ),

                const SizedBox(height: 50),

                MyRow(
                  text: "Have an account?",
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
      ),
    );
  }
}
