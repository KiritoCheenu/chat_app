import 'package:chat_app/Widgets/chat/messageBubble.dart';
import 'package:chat_app/models/MessageModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swipe_to/swipe_to.dart';

class Messages extends StatelessWidget {
  final ValueChanged<MessageModel> onSwipedMessage;

  const Messages({Key key, this.onSwipedMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        else if (!chatSnapshot.hasData) return Container();

        final chatDocs = chatSnapshot.data.docs;
        final user = FirebaseAuth.instance.currentUser;

        return ListView.builder(
            physics: BouncingScrollPhysics(),
            reverse: true,
            itemCount: chatDocs.length,

            itemBuilder: (ctx, index) {

              var message = MessageModel(
                isSeen: chatDocs[index]['messageSeen'],
                text: chatDocs[index]['text'],
                createdAt: chatDocs[index]['createdAt'],
                userId: chatDocs[index]['userId'],
                username: chatDocs[index]['username'],
                userImage: chatDocs[index]['userImage'],
                replyMessage:chatDocs[index]['replyTo']==null?null:MessageModel(
                  username: chatDocs[index]['replyTo']['username'],
                  userId: chatDocs[index]['replyTo']['userId'],
                  createdAt: chatDocs[index]['replyTo']['createdAt'],
                  text: chatDocs[index]['replyTo']['text'],
                )
              );
              bool isMe = chatDocs[index]['userId'] == user.uid;
              return SwipeTo(
                child: MessageBubble(
                  message: message,
                  isMe: isMe,
                  key: ValueKey(chatDocs[index].id),
                ),
                onRightSwipe: isMe ? null : () => onSwipedMessage(message),
                onLeftSwipe: isMe ? () => onSwipedMessage(message) : null,
              );
            });
      },
    );
  }
}
