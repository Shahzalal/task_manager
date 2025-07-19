// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmanager/screens/login_screen.dart';
import 'package:taskmanager/screens/update_profile_screen.dart';
import 'package:taskmanager/utils/userdata.dart';

class MyAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final bool isTappable;
  const MyAppBarWidget({Key? key, this.isTappable = true}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Future<void> _loadUserData() async {
    await UserData.loadFromPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return AppBar(title: Text("Loading..."));
        }

        final String fullName =
            "${UserData.firstName ?? ''} ${UserData.lastName ?? ''}".trim();
        final String email = UserData.email ?? '';

        return AppBar(
          backgroundColor: const Color(0xFFA1045A),
          title: InkWell(
            onTap: () {
              if (!isTappable) return;
              UserData.loadFromPrefs();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UpdateProfileScreen()),
              ).then((updated) async {
                if (updated == true) {
                  await UserData.loadFromPrefs();
                  (context as Element).reassemble();
                }
              });
            },
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundImage:
                    (UserData.photo != null && UserData.photo!.isNotEmpty)
                    ? NetworkImage(UserData.photo!)
                    : const AssetImage("assets/images/user.JPG")
                          as ImageProvider,
              ),
              title: Text(
                fullName.isNotEmpty ? fullName : "User Name",
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "regular",
                ),
              ),
              subtitle: Text(
                email.isNotEmpty ? email : "example@email.com",
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "regular",
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                final SharedPreferences sharedPrefs =
                    await SharedPreferences.getInstance();
                await sharedPrefs.clear();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
              icon: const Icon(Icons.logout, size: 20, color: Colors.white),
            ),
          ],
        );
      },
    );
  }
}
