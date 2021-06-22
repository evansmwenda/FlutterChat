import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/homepage.dart';
import 'package:flutter_chat/screens/login_screen.dart';
import 'package:flutter_chat/widgets/my_appbar.dart';
import 'package:flutter_chat/widgets/my_buttons.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';
  const RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final aboutController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool _isLoading = false;
  String email, password, name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Register"),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 25.0),
        child: Center(
          child: _isLoading ? CircularProgressIndicator(
              backgroundColor: Colors.black,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)) :
          Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(height: 80.0),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.red,
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 5.0,
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Enter valid full name";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
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
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.red,
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 5.0,
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Enter valid phone number";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.blueAccent,
                  controller: aboutController,
                  decoration: InputDecoration(
                    labelText: "About Me",
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 5.0,
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Enter valid about me details";
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
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
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
                SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account ?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, LoginScreen.routeName);
                        },
                        child: Text("Login"),
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
                      "Sign Up".toUpperCase(),
                      () => _beginRegister(context),
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

  void _beginRegister(BuildContext context) {
    print("beginning register");
    if (_formKey.currentState.validate()) {
      //register user
      setState(() {
        _isLoading = true;
      });
      _registerUser();
    }
  }

  void _registerUser() {
    print(emailController.text);
    print(passController.text);
    print(phoneController.text);
    print(aboutController.text);
    firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passController.text)
        .then((result) {
      print("result from register->" + result.user.uid);
      addUser(result.user.uid).then((res) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Homepage(uid: result.user.uid)),
        );
      });
    }).catchError((err) {
      setState(() {
        _isLoading = true;
      });
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

  Future<void> addUser(String uid) {
    return users
        .doc(uid)
        .set({
          'id': uid,
          'name': nameController.text,
          'email': emailController.text, // John Doe
          'phone': phoneController.text, // 0712345678
          'about': aboutController.text, // about me
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    phoneController.dispose();
    aboutController.dispose();
  }
}
