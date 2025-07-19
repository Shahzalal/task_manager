import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData with ChangeNotifier {
  static String? token, email, firstName, lastName, photo, phone;

  static Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    email = prefs.getString("email");
    firstName = prefs.getString("firstName");
    lastName = prefs.getString("lastName");
    phone = prefs.getString("phone");
    photo = prefs.getString("photo");
  }

  static Future<void> updateProfileData({
    required String email,
    required String firstName,
    required String lastName,
    required String phone,
    required String photo,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("email", email);
    await prefs.setString("firstName", firstName);
    await prefs.setString("lastName", lastName);
    await prefs.setString("phone", phone);
    await prefs.setString("photo", photo);

    // Update static fields
    UserData.email = email;
    UserData.firstName = firstName;
    UserData.lastName = lastName;
    UserData.phone = phone;
    UserData.photo = photo;
  }
}
