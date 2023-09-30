import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixme_flutter/chat_screen.dart';
import 'package:flutter/material.dart';

class MessageStreamBuilder extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;
  final chatid;

  MessageStreamBuilder({
    required this.chatid,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('Message')
          .where('chatid', isEqualTo: chatid)
          .where('createduser',
              isEqualTo: FirebaseAuth.instance.currentUser?.email)
          .orderBy('time')
          .snapshots(),
      builder: (context, snapshot) {
        List<MessageLine> messageWidgets = [];

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ),
          );
        }
        final messages = snapshot.data!.docs.reversed;
        log(messages.toString());
        for (var message in messages) {
          final messageText = message.get('text');
          final messageSender = message.get('sender');
          final currentUser = FirebaseAuth.instance.currentUser?.email;

          final messageWidget = MessageLine(
            text: messageText,
            sender: messageSender,
            isMe: currentUser == messageSender,
          );
          messageWidgets.add(messageWidget);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 20,
            ),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}
