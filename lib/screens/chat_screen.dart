import 'package:flutter/material.dart';
import 'package:flutter_chat/models/chat_message.dart';
import 'package:flutter_chat/widgets/my_appbar.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat-screen';
  const ChatScreen({Key key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatMessage> messages = [
    ChatMessage(messageContent: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit sed diam nonummy nibh adipiscing elit sed diam nonummy nibh", messageType: "receiver"),
    ChatMessage(messageContent: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit sed diam nonummy nibh adipiscing elit sed diam nonummy nib", messageType: "sender"),
    ChatMessage(messageContent: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit sed diam nonummy nibh adipiscing elit sed diam nonummy nib", messageType: "receiver"),
    ChatMessage(messageContent: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit sed diam nonummy nibh adipiscing elit sed diam nonummy nib?", messageType: "sender"),
    ChatMessage(messageContent: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit sed diam nonummy nibh adipiscing elit sed diam nonummy nib", messageType: "receiver"),
    ChatMessage(messageContent: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit sed diam nonummy nibh adipiscing elit sed diam nonummy nib?", messageType: "sender"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Jane Doe"),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: messages.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10,bottom: 10),
            // physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
              return Container(
                padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                child: Align(
                  alignment: (messages[index].messageType == "receiver"?Alignment.topLeft:Alignment.topRight),
                  child: Column(
                    crossAxisAlignment: (messages[index].messageType == "receiver"?
                    CrossAxisAlignment.start:CrossAxisAlignment.end),
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: (messages[index].messageType == "receiver"?
                          BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ):
                          BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          )),
                          color: (messages[index].messageType  == "receiver"?Colors.grey.shade200:Colors.blue[700]),
                        ),
                        padding: EdgeInsets.all(16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical:5.0,horizontal: 8.0),
                          child: Text(messages[index].messageContent, style: TextStyle(fontSize: 15,
                              color: messages[index].messageType  == "receiver"?Colors.black:Colors.white),),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 5),
                        child: Text("4:20 PM",style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  SizedBox(width: 15,),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none
                      ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  FloatingActionButton(
                    onPressed: (){
                      print("send message");
                    },
                    child: Icon(Icons.send,color: Colors.white,size: 18,),
                    backgroundColor: Colors.blue[700],
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
}
