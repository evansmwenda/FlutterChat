import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/chat_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
      child: ListView(
        children: [
          ListTile(
            onTap: ()=> _gotoChats(),
            title: Text("Evans Mwenda"),
            subtitle: Text("What did you have for lunch"),
            leading: CircleAvatar(
              radius: 20.0,
              // backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/user.webp'),
            ),
          ),
          Divider(),
          ListTile(
            onTap: ()=> _gotoChats(),
            title: Text("Evans Mwenda"),
            subtitle: Text("What did you have for lunch"),
            leading: CircleAvatar(
              radius: 20.0,
              // backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/user.webp'),
            ),
          ),
          Divider(),
          ListTile(
            onTap: ()=> _gotoChats(),
            title: Text("Evans Mwenda"),
            subtitle: Text("What did you have for lunch"),
            leading: CircleAvatar(
              radius: 20.0,
              // backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/user.webp'),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  void _gotoChats(){
    print("clicked chat");
    Navigator.pushNamed(context,ChatScreen.routeName);
  }
}
