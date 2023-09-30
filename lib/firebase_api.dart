// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
//
// class FirebaseAPI {
//   final firebaseMessaging = FirebaseMessaging.instance;
//
//   Future<void> initNotifications() async {
//     await firebaseMessaging.requestPermission();
//     final fCMToken = await firebaseMessaging.getToken();
//     print('Token$fCMToken');
//   }
//
//   voidhandlemessage(RemoteMessage? message) {
//     if (message == null) return;
//     Navigator.of(context).pushNamed('');
//   }
// }
