import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/chat_screen.dart';
import 'package:flutter_chat/screens/homepage.dart';
import 'package:flutter_chat/screens/login_screen.dart';
import 'package:flutter_chat/screens/register_screen.dart';
import 'package:flutter_chat/screens/tabs/search_tab.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // fontFamily: 'Montserrat',
      ),
      debugShowCheckedModeBanner: false, //uncomment this line in production
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(), //
        LoginScreen.routeName: (context) => LoginScreen(), //LoginScreen
        RegisterScreen.routeName: (context) => RegisterScreen(), //RegisterScreen
        Homepage.routeName: (context) => Homepage(), //Homepage
        ChatScreen.routeName: (context) => ChatScreen(), //ChatScreen
      },
    ),
  );
}