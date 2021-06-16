import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/my_appbar.dart';

class Homepage extends StatefulWidget {
  static const routeName = '/homepage';
  const Homepage({Key key, String uid}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "FlutterChat"),
      body: Container(),
    );
  }
}
