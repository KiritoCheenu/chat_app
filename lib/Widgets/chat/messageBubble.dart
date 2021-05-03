import 'package:chat_app/Widgets/chat/replyMessage.dart';
import 'package:chat_app/models/MessageModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;

  // final String message;
  final bool isMe;

  MessageBubble({this.message, this.isMe, key})
      : super(key: key);

  // final String username;
  // final String userImage;
  // final bool seen;
  // final Timestamp createdAt;

  // Key key1 =UniqueKey();
  // final focusNode= FocusNode();
  // MessageBubble(this.message, this.username, this.userImage, this.isMe,
  //     this.seen, this.createdAt,
  //     {key})
  //     : super(key: key);

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
            Container(
                decoration: BoxDecoration(
                  color:
                  isMe ? Colors.greenAccent : Theme
                      .of(context)
                      .accentColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft:
                      !isMe ? Radius.circular(0) : Radius.circular(12),
                      bottomRight:
                      isMe ? Radius.circular(0) : Radius.circular(12)),
                ),
                width: 140,
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                margin: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 30,
                ),
                child:buildMessage(context)
            ),
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
        // TODO message swiping using Gesture Detector
        // TODO Date and time stamp
        // TODO Read Receipt
      ],
      clipBehavior: Clip.none,
    );
  }

  Widget buildMessage(BuildContext context) {
    return Column(
      crossAxisAlignment:
      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          message.username,
          style: TextStyle(
            color: isMe ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          message.text,
          style: TextStyle(
              color: isMe
                  ? Colors.black
                  : Theme
                  .of(context)
                  .accentTextTheme
                  .headline1
                  .color),
          textAlign: isMe ? TextAlign.end : TextAlign.start,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text(timestamptoHour(message.createdAt)),
          if (isMe)
            message.isSeen
                ? Icon(
              Icons.done_all,
              color: Colors.blue,
              size: 20,
            )
                : Icon(
              Icons.done_all,
              color: Colors.grey,
              size: 20,
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
        child: ReplyMessageWidget(message: replyMessage),
      );
    }
  }

}
