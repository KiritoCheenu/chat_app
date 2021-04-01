import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (ctx, index) => Container(
          padding: EdgeInsets.all(10),
          child: Text('Hi'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {

          FirebaseFirestore.instance
              .collection('chats/UQSomxCF6MiMQT0R0lKx/messages')
              .snapshots()
              .listen((data) {
            print(data.docs[0]['text']);
          });
        },
      ),
    );
  }
}
