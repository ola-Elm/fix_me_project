import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixme_flutter/message_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

final _firestore = FirebaseFirestore.instance;
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
late User signInUser;
late String userId;

class ChatScreen extends StatefulWidget {
  //final String? createduser;
  final String? index;

  const ChatScreen({
    this.index,
    // this.createduser,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? messageText;

  @override
  void initState() {
    myrequestPermission();
    getCurrentUser();
    // getToken();
    super.initState();
  }

  getToken() async {
    String? myToken = await FirebaseMessaging.instance.getToken();
    print('===========zvxzvdxfb=================');
    print(myToken);
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signInUser = user;
        print(signInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  myrequestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // Future<void> sendMessage(String receivedId, String message) async {
  //   final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  //   final String currentUserEmail =
  //       FirebaseAuth.instance.currentUser!.email.toString();
  //   final Timestamp timestamp = Timestamp.now();
  //
  //   //creat new message
  //
  //   Message newMessage = Message(
  //     senderId: currentUserId,
  //     senderEmail: currentUserEmail,
  //     receiverId: receivedId,
  //     timestamp: 'timestamp',
  //     message: message,
  //   );
  // }

//SEND  message===================
  sendMessage(title, message, chatId) async {
    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'PostmanRuntime/7.33.0',
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAAGGziJM:APA91bGiE8SfKXfBET83j6EkaiJj6WlTQnVdQGzZod_Ryq7juUS1z_i3M_QIa-NtDGJIEpKVM5BnAK8bjR-he5aYrxsPDg7UY4iE25tqzEWLNXaKZEI3Xdj5cl2Eiav-P9Xaba5Okzsl'
    };
    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    var future = await FirebaseFirestore.instance
        .collection('chat')
        .where('chatid', isEqualTo: chatId)
        .get();
    var data = future.docs[0].data();
    var fcmtoken = '';
    if (data['createduser'] == FirebaseAuth.instance.currentUser!.email) {
      var us = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: data['enduser'])
          .get();
      fcmtoken = us.docs[0]['fcm_token'];
    } else {
      var us = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
          .get();
      fcmtoken = us.docs[0]['fcm_token'];
    }
    var body = {
      "to": fcmtoken,
      "data": {
        "title": title,
        "body": message,
      },
      "notification": {
        "title": title,
        "body": message,
      }
    };

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode <= 300) {
      print(resBody);
    } else {
      print('==================================');
      print(res.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[300],
        title: Row(
          children: [
            Text(
              '${signInUser.email}',
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              _auth.signOut();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //////////////////////////////////////''''''''''''''''''''//////////////////////////////////////
            MessageStreamBuilder(chatid: widget.index),
            //////////////////////////////////////
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.orange,
                    width: 2,
                  ),
                ),
              ),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                  child: TextField(
                    controller: messageTextController,
                    onChanged: (value) {
                      messageText = value;
                    },
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      hintText: 'Write your message here...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    messageTextController.clear();
                    // Message message= Message(
                    //   senderId:  signInUser.uid,
                    //   senderEmail: signInUser.email.toString(),
                    //   receiverId: ,
                    //   timestamp: FieldValue.serverTimestamp(),
                    //   message: messageText.toString(),
                    // ),

                    _firestore.collection('Message').add({
                      'text': messageText,
                      'chatid': widget.index,
                      'createduser': FirebaseAuth.instance.currentUser?.email,
                      'sender': signInUser.email,
                      'senderID': signInUser.uid,
                      'time': FieldValue.serverTimestamp(),
                    });
                    await sendMessage(
                        'signInUser.email', messageText, widget.index);
                    // Navigator.of(context).pushNamed('chats');
                  },
                  child: Text(
                    'Send',
                    style: TextStyle(
                      color: Colors.blue[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

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

class MessageLine extends StatelessWidget {
  const MessageLine({Key? key, this.text, this.sender, required this.isMe})
      : super(key: key);

  final String? text;
  final String? sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '$sender',
            style: TextStyle(
              fontSize: 12,
              color: Colors.yellow[900],
            ),
          ),
          Material(
            elevation: 5,
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
            color: isMe ? Colors.blue[800] : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                '$text',
                style: TextStyle(
                  fontSize: 20,
                  color: isMe ? Colors.white : Colors.black45,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    ;
  }
}
