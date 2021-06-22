import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_chat/widgets/my_appbar.dart';
import 'package:flutter_chat/widgets/route_arguments.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat-screen';
  final String peerUid;
  final String userUid;
  final String name;
  const ChatScreen({this.peerUid, this.userUid,this.name});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String conversationID;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController messageController = new TextEditingController();
  CollectionReference messagesCollection = FirebaseFirestore.instance.collection('messages');
  Stream<QuerySnapshot> _messagesStream;
  Timestamp time;
  ScrollController _scrollController = new ScrollController();

  @override
  initState() {
    super.initState();
    conversationID = getConversationID(widget.peerUid, widget.userUid);
    print("conversation id->>> $conversationID");
    _messagesStream = FirebaseFirestore.instance
        .collection('messages')
        .doc(conversationID)
        .collection(conversationID)
        .snapshots();
    print("stream->"+_messagesStream.toList().toString());
  }

  String getConversationID(String userID, String peerID) {
    return userID.hashCode <= peerID.hashCode
        ? userID + '_' + peerID
        : peerID + '_' + userID;
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: MyAppBar(title: widget.name),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: _messagesStream,
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
                      int timeInMillis = int.parse(data['timestamp']);
                      var date = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
                      var formattedDate = DateFormat('MM/dd, hh:mm a').format(date); // 12/31, 11:59 pm
                      return Container(
                        padding:
                        EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                        child: Align(
                          alignment: (widget.userUid == data['idTo'] //"receiver"
                              ? Alignment.topLeft
                              : Alignment.topRight),
                          child: Column(
                            crossAxisAlignment:
                            (widget.userUid == data['idTo'] //"receiver"
                                ? CrossAxisAlignment.start
                                : CrossAxisAlignment.end),
                            children: [
                              Container(
                                margin: widget.userUid == data['idTo'] //"receiver"
                                    ? EdgeInsets.only(right: 50.0)
                                    : EdgeInsets.only(left: 50.0),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  (widget.userUid == data['idTo'] //"receiver"
                                      ? BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  )
                                      : BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                  )),
                                  color: (widget.userUid == data['idTo'] //"receiver"
                                      ? Colors.grey[400]
                                      : Colors.blue),
                                ),
                                padding:
                                EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 5.0),
                                  child: Text(
                                    data['content'],
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: widget.userUid == data['idTo'] //"receiver"
                                            ? Colors.black
                                            : Colors.white),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0,right: 8.0, top: 2,bottom:5),
                                child: Text(
                                 "$formattedDate",//+ DateTime.parse(data['timestamp']).toString(),
                                  style: TextStyle(fontWeight: FontWeight.w300,fontSize: 11.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
          ),

          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 5),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      _sendMessage();
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    print("sending message"+messageController.text);
    String myTimestamp = DateTime.now().millisecondsSinceEpoch.toString();
    print("timestamp $myTimestamp");

    if(messageController.text ==""){
      print("you cant sent empty messages");
      return;
    }

    //write message to firestore database
    messagesCollection
        .doc(conversationID)
        .collection(conversationID)
        .doc(myTimestamp)
        .set({
      'content': messageController.text, // John Doe
      'idFrom': widget.userUid,
      'idTo': widget.peerUid,
      'read': false,
      'timestamp' : myTimestamp
    })
        .then((value){ print("Message Sent");messageController.clear();})
        .catchError((error) => print("Failed to add user: $error"));
  }

}
