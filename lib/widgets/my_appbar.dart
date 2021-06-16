import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  MyAppBar({this.title});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(

              colors: [
                const Color(0xffff0000),
                const Color(0xff6b0000),
              ],
            ),
          ),
        )
    );
  }
}
