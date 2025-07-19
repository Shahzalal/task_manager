import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmanager/screens/login_screen.dart';
import 'package:taskmanager/screens/main%20screen/main_screen.dart';
import 'package:taskmanager/utils/userdata.dart';
import 'package:taskmanager/widgets/backgroundimage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      gotoNextScreen();
    });
  }

  Future<void> gotoNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));

    final sharedPrefs = await SharedPreferences.getInstance();
    final String? token = sharedPrefs.getString('token');

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      // Load user data into UserData
      UserData.token = token;
      UserData.firstName = sharedPrefs.getString("firstName");
      UserData.lastName = sharedPrefs.getString("lastName");
      UserData.email = sharedPrefs.getString("email");
      UserData.phone = sharedPrefs.getString("mobile");
      UserData.photo = sharedPrefs.getString("photo");

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => TaskDashboardScreen()),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundImage(
        child: Center(child: SvgPicture.asset("assets/images/logo.svg")),
      ),
    );
  }
}
