import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
  final _fireSotre = Firestore.instance;

mixin Firestore {
  static var instance;
}
  FirebaseUser loggedInUser;

mixin FirebaseUser {
  Object get email => null;
}

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  String messageText;
  final messageTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user as FirebaseUser;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  //  void getMessages() async{
  //    final messages = await  _fireSotre.collection(
  //      'messages'
  //    ).getDocuments();
  //    for(var message  in messages.documents){
  //      print(message.data);
  //    }
  //  }

  void messageStream() async {
    await for (var snapshot in _fireSotre.collection('messages').snapshots()) {
      for (var message in snapshot.documents) {
        print(message.data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                // messageStream();
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                        color: Colors.black,
                       ),
                       controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    
                    onPressed: () {
                      messageTextController.clear();
                      _fireSotre.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
              
              stream: _fireSotre.collection('messages').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }
                final messages = snapshot.data.documents.reversed;
                List<MessageBubble> messagesWidgets = [];

                for (var message in messages) {
                  final messagesText = message.data['text'];
                  final messagesSender = message.data['sender'];
                  final currentUser  = loggedInUser.email;

                  if(currentUser == messagesSender){

                  }
                  final messagesBubble = MessageBubble(
                    sender: messagesSender,
                    text:  messagesText,
                    isME: currentUser == messagesSender,
                    );

                  messagesWidgets.add(messagesBubble);
                }

                return Expanded(
                  child: ListView(
                    reverse: true,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    children: messagesWidgets,
                  ),
                );
              },
            );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.text, this.sender,this.isME});
  final String text;
  final bool  isME;
  final String sender;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: isME ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget> [
          Text(
            sender,
            style:  TextStyle(
              fontSize: 11.0,
              color : Colors.black54,
              
               ),
            ),
            SizedBox(
              height: 5.0,
            ),
          Material(
            
            borderRadius: 
            isME ? BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            bottomLeft: Radius.circular(30)) 
            : BorderRadius.only(
              topLeft: Radius.circular(30)
            ,topRight: Radius.circular(30)
            ,bottomRight: Radius.circular(30)),
            elevation: 6.0, 
            color: isME ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
              child: Text(
                text,   
                style: TextStyle(
                  color: isME ? Colors.white : Colors.black54,
                  fontSize: 13.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
