import 'package:chat_app/Widgets/chat/replyMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String username;
  final String userImage;
  final bool seen;
  final Timestamp createdAt;

  // Key key1 =UniqueKey();
  // final focusNode= FocusNode();
  MessageBubble(this.message, this.username, this.userImage, this.isMe,
      this.seen, this.createdAt,
      {key})
      : super(key: key);
  String timestamptoHour(Timestamp time){
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
            SwipeTo(
              onRightSwipe: isMe
                  ? null
                  : () {
                      return ReplyMessageWidget(
                        key: key,
                      );
                    },
              onLeftSwipe: isMe
                  ? () {
                      return ReplyMessageWidget(
                        key: key,
                      );
                    }
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  color:
                      isMe ? Colors.greenAccent : Theme.of(context).accentColor,
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
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: TextStyle(
                        color: isMe ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      message,
                      style: TextStyle(
                          color: isMe
                              ? Colors.black
                              : Theme.of(context)
                                  .accentTextTheme
                                  .headline1
                                  .color),
                      textAlign: isMe ? TextAlign.end : TextAlign.start,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                      Text(timestamptoHour(createdAt)),
                      if (isMe)
                        seen
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
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: -5,
          left: isMe ? null : 10,
          right: isMe ? 10 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImage),
          ),
        ),
        // TODO message swiping using Gesture Detector
        // TODO Date and time stamp
        // TODO Read Receipt
      ],
      clipBehavior: Clip.none,
    );
  }
}
