import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key key}) : super(key: key);

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String  _userName, _emailAddress;
  SharedPreferences _prefs;
  final User user = FirebaseAuth.instance.currentUser;
  Stream<QuerySnapshot> _messagesStream;
  CollectionReference users = FirebaseFirestore.instance.collection('users');


  @override
  void initState() {
    ////filter user list
    super.initState();
    // _messagesStream = FirebaseFirestore.instance
    //     .collection('users'
    //     .doc(user.uid)
    //     .snapshots();
  }

  Future<void> getPrefs() async {
    _prefs = await SharedPreferences.getInstance();

    _userName = await _prefs.getString('fullName') ?? "";
    _emailAddress = await _prefs.getString('emailAddress') ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: ListView(
          children: [
            Container(
              color: Colors.white,
              height: 160,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      height: 150,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.blue[700], width: 2.5),
                                  ),
                                  child: IconButton(
                                    onPressed: (){},
                                    icon: Icon(
                                      Icons.perm_identity,
                                      size: 73,
                                    ),
                                  ),
                                ),
                                Positioned(
                                    bottom: 0,
                                    right: 0,
                                    left: 78,
                                    height: 35,
                                    child: FloatingActionButton(
                                      child: Icon(Icons.camera_alt_outlined),
                                      onPressed: () {
                                        print("clicked change photo");
                                      },
                                    )),
                              ],
                            ),
                            FutureBuilder<DocumentSnapshot>(
                              future: users.doc(user.uid).get(),
                              builder:
                                  (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                                if (snapshot.hasError) {
                                  return Text("Something went wrong");
                                }

                                if (snapshot.hasData && !snapshot.data.exists) {
                                  return Text("Document does not exist");
                                }

                                if (snapshot.connectionState == ConnectionState.done) {
                                  Map<String, dynamic> data = snapshot.data.data() as Map<String, dynamic>;
                                  return _buildUserData(data);
                                  // return Text("Full Name: ${data['full_name']} ${data['last_name']}");
                                }

                                return Text("loading");
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserData(var data) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            // data.getString("fullName") ?? "John Doe",
            data['name'] ?? "",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            // data.getString("emailAddress") ?? "johndoe@gmail.com",
            data['email'] ?? "",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
