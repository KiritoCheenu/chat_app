import 'package:chat_app/Widgets/chat/messages.dart';
import 'package:chat_app/Widgets/chat/newMessage.dart';
import 'package:chat_app/models/MessageModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final focusNode = FocusNode();
  MessageModel replyMessage;
  @override
  void initState() {
    // TODO: implement initState
    messageSeen();

    print('Run... initState');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    messageSeen();
    // TODO: implement didChangeDependencies

    print('Run... DidchangeDependency');
    super.didChangeDependencies();
  }

  void messageSeen() {
    int count;
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) => count = value.size);
    final user = FirebaseAuth.instance.currentUser;

    // print(users);

    FirebaseFirestore.instance.collection('chat').get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        var userList = doc['usersSeen'];
        if (!userList.contains(user.uid) && user.uid != doc['userId'])
          userList.add(user.uid);

        bool seen = count == null ? false : userList.length == (count - 1)
            ? true
            : false;
        // print(seen);
        FirebaseFirestore.instance.collection('chat').doc(doc.id).update({
          "usersSeen": userList,
          'messageSeen': seen,
        });
      });
    });
    print('Run...');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme
                  .of(context)
                  .primaryIconTheme
                  .color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Logout')
                    ],
                  ),
                ),
                value: 'logout',
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Messages(onSwipedMessage: (message){
                replyToMessage(message);
                focusNode.requestFocus();
              },),
            ),
          ),

          NewMessage(
            focusNode: focusNode,
            // idUser: widget.user.idUser,
            onCancelReply: cancelReply,
            replyMessage: replyMessage,
          ),
        ],
      ),
    );
  }
  void replyToMessage(MessageModel message) {
    setState(() {
      replyMessage = message;
    });
  }
  void cancelReply() {
    setState(() {
      replyMessage = null;
    });
  }
}
