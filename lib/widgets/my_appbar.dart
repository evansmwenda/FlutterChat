import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/login_screen.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  MyAppBar({this.title});

  @override
  Size get preferredSize => const Size.fromHeight(56);



  @override
  Widget build(BuildContext context) {
    Future<void> _signOut() async {
      print("logging out");
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginScreen()),
      );
    }

    return AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              color: Colors.white,
              onPressed: () => _signOut())
        ],
        title: Text(title),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xff005eff),
                const Color(0xff002b6b),
              ],
            ),
          ),
        ));
  }
}
