import 'package:chat_app/Widgets/chat/messageBubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
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
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, index) => MessageBubble(
            chatDocs[index]['text'],
            chatDocs[index]['username'],
            chatDocs[index]['userId'] == user.uid,
            key: ValueKey(chatDocs[index].id),
          ),
        );
      },
    );
  }
}
