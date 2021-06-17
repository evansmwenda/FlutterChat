import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({Key key}) : super(key: key);

  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  TextEditingController controller = new TextEditingController();
  final User user = FirebaseAuth.instance.currentUser;
  Stream<QuerySnapshot> _usersStream =
  FirebaseFirestore.instance.collection('users').snapshots();
  CollectionReference messagesCollection = FirebaseFirestore.instance.collection('messages');

  List<UserDetails> _searchResult = [];

  List<UserDetails> _userDetails = [];

  final String url = 'https://jsonplaceholder.typicode.com/users';

  // Get json result and convert it to model. Then add
  Future<Null> getUserDetails() async {
    final response = await http.get(Uri.parse(url));
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map user in responseJson) {
        _userDetails.add(UserDetails.fromJson(user));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
    _usersStream =
        FirebaseFirestore.instance.collection('users').where("id", isNotEqualTo: user.uid).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Container(
          color: Theme.of(context).primaryColor,
          child: new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Card(
              child: new ListTile(
                leading: new Icon(Icons.search),
                title: new TextField(
                  controller: controller,
                  decoration: new InputDecoration(
                      hintText: 'Search', border: InputBorder.none),
                  onChanged: onSearchTextChanged,
                ),
                trailing: new IconButton(
                  icon: new Icon(Icons.cancel),
                  onPressed: () {
                    controller.clear();
                    onSearchTextChanged('');
                  },
                ),
              ),
            ),
          ),
        ),
        new Expanded(
          child: StreamBuilder<QuerySnapshot>(
                  stream: _usersStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }

                    return new ListView(
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        return new ListTile(
                          onTap: () => _showDialog(data['name'], data['id']),
                          title: Text(data['name']),
                          subtitle: Text(data['email']),
                          leading: CircleAvatar(
                            radius: 20.0,
                            // backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage('assets/user.webp'),
                          ),
                        );
                      }).toList(),
                    );
                  })
,
        ),
      ],
    );
  }

  onSearchTextChanged(String text) async {
    print("searching ->"+text);
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _userDetails.forEach((userDetail) {
      if (userDetail.firstName.contains(text) ||
          userDetail.lastName.contains(text)) _searchResult.add(userDetail);
    });

    setState(() {});
  }

  void _showDialog(String name,String uid) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Let\'s Chat"),
            content: Text("Send Chat Request to $name?"),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _sendChatRequest(uid);
                },
              ),
              TextButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _sendChatRequest(String uid) {
    //write message to firestore database
    print("sending chat request");
    String myTimestamp = DateTime.now().millisecondsSinceEpoch.toString();
    print("timestamp $myTimestamp");

    String conversationID = getConversationID(
      user.uid,uid
    );
    print("conversationID $conversationID");

    messagesCollection
        .doc(conversationID)
        .collection(conversationID)
        .doc(myTimestamp)
        .set({
      'content': "Heyy, Let's chat", // John Doe
      'idFrom': user.uid,//current users uid
      'idTo': uid,//new friend's uid
      'read': false,
      'timestamp': myTimestamp
    }).then((value) {
      print("Message Sent");
    }).catchError((error) => print("Failed to add user: $error"));
  }

  String getConversationID(String userID, String peerID) {
    return userID.hashCode <= peerID.hashCode
        ? userID + '_' + peerID
        : peerID + '_' + userID;
  }
}

class UserDetails {
  final int id;
  final String firstName, lastName, profileUrl;

  UserDetails(
      {this.id,
      this.firstName,
      this.lastName,
      this.profileUrl =
          'https://i.amz.mshcdn.com/3NbrfEiECotKyhcUhgPJHbrL7zM=/950x534/filters:quality(90)/2014%2F06%2F02%2Fc0%2Fzuckheadsho.a33d0.jpg'});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return new UserDetails(
      id: json['id'],
      firstName: json['name'],
      lastName: json['username'],
    );
  }
}
