import 'package:chat_app/Widgets/chat/replyMessage.dart';
import 'package:chat_app/models/MessageModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;

  // final String message;
  final bool isMe;

  MessageBubble({this.message, this.isMe, key}) : super(key: key);

  String timestamptoHour(Timestamp time) {
    DateTime now = time.toDate();
    DateFormat formatter = DateFormat('h:mm a');
    String formatted = formatter.format(now);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.75,minWidth: MediaQuery.of(context).size.width*.25),
              child: Container(
                  decoration: BoxDecoration(
                    color: isMe ? Colors.teal : Colors.black38,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft:
                            !isMe ? Radius.circular(0) : Radius.circular(12),
                        bottomRight:
                            isMe ? Radius.circular(0) : Radius.circular(12)),
                  ),
                  // width: MediaQuery.of(context).size.width*.5,
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  margin: EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 30,
                  ),
                  child: Column(
                    crossAxisAlignment: isMe && message.replyMessage == null
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: <Widget>[
                      buildReplyMessage(),
                      buildMessage(context),
                    ],
                  )),
            ),
            // Spacer(flex: 1,)
          ],
        ),
        Positioned(
          top: -5,
          left: isMe ? null : 10,
          right: isMe ? 10 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(message.userImage),
          ),
        ),
      ],
      clipBehavior: Clip.none,
    );
  }

  Widget buildMessage(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if(!isMe)
        Text(
          message.username,
          style: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          message.text,
          style: TextStyle(color: Colors.white70,fontSize: 18),
          textAlign: isMe ? TextAlign.end : TextAlign.start,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text(
            timestamptoHour(message.createdAt),
            style: TextStyle(color: Colors.white60,fontSize: 13),
          ),
          if (isMe)
            message.isSeen
                ? Icon(
                    Icons.done_all,
                    color: Colors.blue,
                    size: 14,
                  )
                : Icon(
                    Icons.done_all,
                    color: Colors.white60,
                    size:16,
                  ),
        ])
      ],
    );
  }

  Widget buildReplyMessage() {
    final replyMessage = message.replyMessage;
    final isReplying = replyMessage != null;

    if (!isReplying) {
      return Container();
    } else {
      return Container(
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
          color: Colors.teal[300],
        ),
        child: ReplyMessageWidget(message: replyMessage),
      );
    }
  }
}
