import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/homepage.dart';
import 'package:flutter_chat/screens/register_screen.dart';
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
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool _isLoading = false;
  String email, password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Login"),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 25.0),
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
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.blue,
                  controller: passController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 5.0,
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Enter valid password";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0,),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don\'t have an account ?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RegisterScreen.routeName);
                        },
                        child: Text("Sign Up"),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: MyElevatedButton(
                      "login".toUpperCase(),
                      () => _beginLogin(context),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  void _beginLogin(BuildContext context) {
    print("beginning login");
    if(_formKey.currentState.validate()){
      //login user
      _loginUser();
    }
  }

  bool _validateFields() {
    String email, pass = "";
    email = emailController.text;
    pass = passController.text;

    if (pass == "" || email == "") {
      //one of the required fields missing
      return false;
    } else {
      return true;
    }
  }

  void _gotoHomepage() {
    Navigator.pushNamed(context, Homepage.routeName);
  }

  void _loginUser() {
    print(emailController.text);
    print(passController.text);
    firebaseAuth
        .signInWithEmailAndPassword(
        email: emailController.text, password: passController.text)
        .then((result) {
      saveUser(result.user.uid);
    }).catchError((err) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.message),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passController.dispose();
  }

  Future<void> saveUser(String uid) {
    print("user id->>"+uid);
    print("saving user details");
    Navigator.pushReplacementNamed(context, Homepage.routeName);
  }
}
