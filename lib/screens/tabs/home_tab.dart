import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/chat_screen.dart';
import 'package:flutter_chat/widgets/route_arguments.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final User user = FirebaseAuth.instance.currentUser;
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  final Stream<QuerySnapshot> _messagesStream =
  FirebaseFirestore.instance.collection('messages').snapshots();






  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: _usersStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return new ListView(
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  return new ListTile(
                    onTap: () => _gotoChats(data['id'],data['name']),
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
            }));
  }
  String getConversationID(String userID, String peerID) {
    return userID.hashCode <= peerID.hashCode
        ? userID + '_' + peerID
        : peerID + '_' + userID;
  }

  void _gotoChats(String uid,String name) {
    print("clicked chat->"+uid);
    String conversationID = getConversationID(user.uid, uid);
    print("conversation id $conversationID");
    //todo: look if document id exists
    // var count = FirebaseFirestore.instance.collection('messages').doc(conversationID).get();
    // var count = FirebaseFirestore.instance.collection('messages')
    //     .where(FieldPath.documentId,isEqualTo: conversationID).get();
    // print("count->>" +count.toString());
    
    //
    // var docRef = FirebaseFirestore.instance.collection("messages").doc(conversationID);
    // docRef.get().then((value) {
    //   if(value.exists){
    //     print("Document data: "+value.id.toString());
    //   }else{
    //     print("No such document!");
    //   }
    // }).catchError((onError){print("getting error "+onError.toString());});


    // print("count->>"+count.toString());
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          peerUid: uid,
          userUid: user.uid,
          name: name,
        ),),);
  }
}
