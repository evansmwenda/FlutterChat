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
  Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  Stream<DocumentSnapshot> _messagesStream =
  FirebaseFirestore.instance.collection('messages').doc().snapshots();
  var lastMesos = new Map();
  List<String> lastMessages= ["Loading...","Losfd"];
  bool shouldReset = true;

  @override
  void initState() {
    ////filter user list
    super.initState();
    _usersStream =
        FirebaseFirestore.instance.collection('users').where("id", isNotEqualTo: user.uid).snapshots();
  }


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
                  print(data['id']);
                  _startMessagesCheck(data['id']);
                  var uuid = data['id'];
                  //hide the current user
                  // if(data['id'] == user.uid){
                    return new ListTile(
                      onTap: () => _gotoChats(data['id'],data['name']),
                      title: Text(data['name']),
                      subtitle: Text(lastMesos[uuid] ?? "Loading..."),
                      leading: CircleAvatar(
                        radius: 20.0,
                        // backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage('assets/user.webp'),
                      ),
                    );
                  //}
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

  _startMessagesCheck(String uid)  {
    //this method fetches last messages
    //1.get the user ids and get the conversation ids from there
    String conversationID = getConversationID(user.uid,uid);
    print("message convo id->>"+conversationID);

    //get the last message of this document collection
    print("printing last message");
    Stream<QuerySnapshot<Map<String, dynamic>>> variable = FirebaseFirestore.instance
        .collection('messages')
        .doc(conversationID)
        .collection(conversationID)
        .snapshots();
    variable.forEach((field) {
      field.docs.asMap().forEach((index, data) {
        String meso = field.docs[index]["content"];
        lastMesos[uid]=meso;
        lastMessages.add(meso);
        print("messog->"+meso);
        //IF I PRINT HERE, IT SHOWS THE PRODUCTS.
      });
    });
    if(shouldReset){
      Future.delayed(Duration(milliseconds: 5000), () {
        // Do something
        setState(() {
          print("i am running again");
          shouldReset = false;
        });
      });


    }
    print("all messages=>"+lastMessages.toString());



  }
}

class Message {
  final String content;
  final String idFrom;
  final String idTo;
  final String timestamp;

  Message({this.content,this.idFrom,this.idTo,this.timestamp});

  factory Message.fromDocument(DocumentSnapshot doc) {
    return Message(
      content: doc['content'],
    );
  }

}
