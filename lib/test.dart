// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
//
// class Test extends StatefulWidget {
//   const Test({super.key});
//
//   @override
//   State<Test> createState() => _TestState();
// }
//
// class _TestState extends State<Test> {
//   var serverToken =
//       'AAAAAGGziJM:APA91bGiE8SfKXfBET83j6EkaiJj6WlTQnVdQGzZod_Ryq7juUS1z_i3M_QIa-NtDGJIEpKVM5BnAK8bjR-he5aYrxsPDg7UY4iE25tqzEWLNXaKZEI3Xdj5cl2Eiav-P9Xaba5Okzsl';
//
//   sendNotify(String title, String body, String id) async {
//     await http.post(
//       Uri.parse("https://fcm.googleapis.com/fcm/send"),
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//         'Authorization': 'key=$serverToken',
//       },
//       body: jsonEncode(
//         <String, dynamic>{
//           'notification': <String, dynamic>{
//             'body': body.toString(),
//             'title': title.toString()
//           },
//           'priority': 'high',
//           'data': <String, dynamic>{
//             'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//             'id': id.toString(),
//           },
//           'to': await FirebaseMessaging.instance.getToken(),
//         },
//       ),
//     );
//   }
//
//   getToken() async {
//     print('==============Token============');
//     var token = await FirebaseMessaging.instance.getToken();
//     print(token);
//   }
//
//   getMessage() async {
//     await FirebaseMessaging.onMessage.listen((event) {
//       print('==============================================');
//       print(event.notification!.title);
//       print(event.notification!.body);
//       print(event.data);
//     });
//   }
//
//   @override
//   void initState() {
//     getMessage();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('TEST'),
//       ),
//       body: MaterialButton(
//         onPressed: () async {
//           await sendNotify('', '', '');
//         },
//         child: const Text(
//           'Send Notify',
//         ),
//       ),
//     );
//   }
// }
