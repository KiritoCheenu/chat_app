import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String userId;
  final String userImage;
  final String username;
  final String text;
  final bool isSeen;
  final Timestamp createdAt;
  final MessageModel replyMessage;

  MessageModel(
      {this.userId,
      this.userImage,
      this.username,
      this.text,
      this.isSeen,
      this.createdAt,
      this.replyMessage});

// MessageModel get replyMessage => _replyMessage;
}
