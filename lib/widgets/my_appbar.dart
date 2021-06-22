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


    return AppBar(
        title: Text(title),);
  }
}
