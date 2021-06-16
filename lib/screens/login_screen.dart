import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/homepage.dart';
import 'package:flutter_chat/widgets/my_appbar.dart';
import 'package:flutter_chat/widgets/my_buttons.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool _isLoading = false;
  String email, password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(height: 110.0),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.red,
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email Address",
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 5.0,
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Enter valid Email Address";
                    }
                  },
                ),
                SizedBox(height: 100,),
                MyElevatedButton(
                    "login".toUpperCase(), ()=> _beginLogin(context))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _beginLogin(BuildContext context) {
    print("beginning login");
  }

  void _gotoHomepage() {
    Navigator.pushNamed(context, Homepage.routeName);
  }
}
