import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixme_flutter/chat.dart';
import 'package:fixme_flutter/chat_screen.dart';
import 'package:fixme_flutter/firebase_message.dart';
import 'package:flutter/material.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({Key? key}) : super(key: key);

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isLoading = true;

  //List users = [];
  List chat = [];

  // CollectionReference userref = FirebaseFirestore.instance.collection('users');
  CollectionReference chatref = FirebaseFirestore.instance.collection('chat');

  // getData() async {
  //   var responcebody = await userref.get();
  //   responcebody.docs.forEach((element) {
  //     setState(() {
  //       users.add(element.data());
  //     });
  //   });
  //   print(users);
  // }

  getsData() async {
    var responcTobody = await chatref
        .where(
          'enduser',
          isEqualTo: FirebaseAuth.instance.currentUser?.email?.trim(),
        )
        .get();
    responcTobody.docs.forEach(
      (element) => chat.add(
        element.data(),
      ),
    );
    print(responcTobody.docs[0].data());
    print(FirebaseAuth.instance.currentUser?.email);
    print(chat);
  }

  @override
  void initState() {
    //getData();
    getsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Text(
          'Chat Home',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("login", (route) => false);
            },
            child: Icon(
              Icons.logout,
              size: 25,
            ),
          )
        ],
      ),
      body: ListView.builder(
          itemCount: chat.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${chat[i]['createduser']} - ${chat[i]['chatid']}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 50),
                          Row(
                            children: [
                              //Accept============================================
                              Material(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue,
                                child: TextButton(
                                  onPressed: () {
                                    AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.warning,
                                        animType: AnimType.rightSlide,
                                        title: 'Success',
                                        desc: 'هل انت موافق على هذه العملية',
                                        btnCancelOnPress: () {
                                          print('Cancel');
                                        },
                                        btnOkOnPress: () async {
                                          /////////
                                          ChatClass chatClass = ChatClass(
                                            chatid: i.toString(),
                                            createduser: FirebaseAuth.instance
                                                    .currentUser!.email ??
                                                '',
                                            enduser: chat[i]['enduser'],
                                          );

                                          await FirebaseFirestore.instance
                                              .collection('chat')
                                              .add(chatClass.toMap());
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                ChatScreen(index: i.toString()),
                                          ));
                                        }).show();
                                  },
                                  child: const Text(
                                    'Accept',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

      /*===============================*/

      // StreamBuilder(
      //   //userref.get()
      //   stream: userref.snapshots(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //       return ListView.builder(
      //         itemCount: snapshot.data!.docs.length,
      //         itemBuilder: (context, i) {
      //           final Map<String, dynamic>? data =
      //           snapshot.data!.docs[i].data() as Map<String, dynamic>?;
      //           final username = data?['username'];
      //
      //           return Text("==========================$username");
      //         },
      //       );
      //     }
      //     if (snapshot.hasError) {
      //       return Text('Error----------------');
      //     }
      //     return Text('Loading>>>>>>>>>>>>>>>>');
      //   },
      // ),
      /*=======================================*/
      // body: isLoading == true
      //     ? const Center(
      //         child: CircularProgressIndicator(),
      //       )
      //     : ListView.builder(
      //         itemCount: data.length,
      //         itemBuilder: (context, i) {
      //           return Container(
      //             padding: const EdgeInsets.all(10),
      //             height: 100,
      //             decoration: BoxDecoration(
      //               borderRadius: const BorderRadius.all(Radius.circular(10)),
      //               color: Colors.grey[300],
      //             ),
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 const SizedBox(
      //                   height: 10,
      //                 ),
      //                 Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   children: [
      //                     Text(
      //                       "${data[i]['title']}",
      //                       style: TextStyle(fontSize: 20),
      //                     ),
      //                     Text(
      //                       "${data[i]['username']}",
      //                       style: TextStyle(fontSize: 20),
      //                     ),
      //                     Material(
      //                       borderRadius: BorderRadius.circular(10),
      //                       color: Colors.blue,
      //                       child: MaterialButton(
      //                         minWidth: 50,
      //                         height: 32,
      //                         elevation: 3,
      //                         onPressed: () {
      //                           Navigator.of(context)
      //                               .pushReplacementNamed('chat');
      //                         },
      //                         child: const Text(
      //                           'Accept',
      //                           style: TextStyle(
      //                             color: Colors.white,
      //                             fontSize: 15,
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                     // Row(
      //                     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     //   children: [
      //                     //     //Accept============================================
      //                     //     Material(
      //                     //       borderRadius: BorderRadius.circular(10),
      //                     //       color: Colors.blue,
      //                     //       child: MaterialButton(
      //                     //         minWidth: 50,
      //                     //         height: 32,
      //                     //         elevation: 3,
      //                     //         onPressed: () {
      //                     //           AwesomeDialog(
      //                     //               context: context,
      //                     //               dialogType: DialogType.warning,
      //                     //               animType: AnimType.rightSlide,
      //                     //               title: 'Success',
      //                     //               desc: 'هل انت موافق على هذه العملية',
      //                     //               btnCancelOnPress: () {
      //                     //                 print('Cancel');
      //                     //               },
      //                     //               btnOkOnPress: () async {
      //                     //                 await FirebaseFirestore.instance
      //                     //                     .collection('customer')
      //                     //                     .doc(data[i].id)
      //                     //                     .delete();
      //                     //                 Navigator.of(context)
      //                     //                     .pushReplacementNamed('chat');
      //                     //               }).show();
      //                     //         },
      //                     //         child: const Text(
      //                     //           'Accept',
      //                     //           style: TextStyle(
      //                     //             color: Colors.white,
      //                     //             fontSize: 15,
      //                     //           ),
      //                     //         ),
      //                     //       ),
      //                     //     ),
      //                     //     const SizedBox(
      //                     //       width: 10,
      //                     //     ),
      //                     //     //Ignore============================================
      //                     //     Material(
      //                     //       borderRadius: BorderRadius.circular(10),
      //                     //       color: Colors.red,
      //                     //       child: MaterialButton(
      //                     //         minWidth: 50,
      //                     //         height: 32,
      //                     //         elevation: 3,
      //                     //         onPressed: () async {
      //                     //           await FirebaseFirestore.instance
      //                     //               .collection('')
      //                     //               .doc(data[i].id)
      //                     //               .delete();
      //                     //           //Navigator.of(context).pushNamed('engHome');
      //                     //           // AwesomeDialog(
      //                     //           //     context: context,
      //                     //           //     dialogType: DialogType.warning,
      //                     //           //     animType: AnimType.rightSlide,
      //                     //           //     title: 'Success',
      //                     //           //     desc: 'هل انت متأكد من هذه العملية',
      //                     //           //     btnCancelOnPress: () {
      //                     //           //       print('Cancel');
      //                     //           //     },
      //                     //           //     btnOkOnPress: () async {
      //                     //           //       await FirebaseFirestore.instance
      //                     //           //           .collection('customer')
      //                     //           //           .doc(data[i].id)
      //                     //           //           .delete();
      //                     //           //       Navigator.of(context)
      //                     //           //           .pushReplacementNamed('engHome');
      //                     //           //     }).show();
      //                     //         },
      //                     //         child: const Text(
      //                     //           'Ignore',
      //                     //           style: TextStyle(
      //                     //             color: Colors.white,
      //                     //             fontSize: 15,
      //                     //           ),
      //                     //         ),
      //                     //       ),
      //                     //     ),
      //                     //   ],
      //                     // ),
      //                   ],
      //                 ),
      //               ],
      //             ),
      //           );
      //         },
      //       ),
    );
  }
}

// Container(
//           child: FutureBuilder(
//             future: customer
//                 .where("UserId",
//                     isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//                 .get(),
//             builder: (context, snapshote) {
//               if (snapshote.hasData) {
//                 return ListView.builder(
//                   itemCount: snapshote.data!.docs.length,
//                   itemBuilder: (context, i) {
//                     return Container(
//                       padding: const EdgeInsets.all(10),
//                       height: 100,
//                       decoration: BoxDecoration(
//                         borderRadius:
//                             const BorderRadius.all(Radius.circular(10)),
//                         color: Colors.grey[300],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "${data[i]['name']}",
//                                 style: TextStyle(fontSize: 20),
//                               ),
//                               Material(
//                                 borderRadius: BorderRadius.circular(10),
//                                 color: Colors.blue,
//                                 child: MaterialButton(
//                                   minWidth: 50,
//                                   height: 32,
//                                   elevation: 3,
//                                   onPressed: () {
//                                     Navigator.of(context)
//                                         .pushReplacementNamed('chat');
//                                   },
//                                   child: const Text(
//                                     'Accept',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 15,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               // Row(
//                               //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               //   children: [
//                               //     //Accept============================================
//                               //     Material(
//                               //       borderRadius: BorderRadius.circular(10),
//                               //       color: Colors.blue,
//                               //       child: MaterialButton(
//                               //         minWidth: 50,
//                               //         height: 32,
//                               //         elevation: 3,
//                               //         onPressed: () {
//                               //           AwesomeDialog(
//                               //               context: context,
//                               //               dialogType: DialogType.warning,
//                               //               animType: AnimType.rightSlide,
//                               //               title: 'Success',
//                               //               desc: 'هل انت موافق على هذه العملية',
//                               //               btnCancelOnPress: () {
//                               //                 print('Cancel');
//                               //               },
//                               //               btnOkOnPress: () async {
//                               //                 await FirebaseFirestore.instance
//                               //                     .collection('customer')
//                               //                     .doc(data[i].id)
//                               //                     .delete();
//                               //                 Navigator.of(context)
//                               //                     .pushReplacementNamed('chat');
//                               //               }).show();
//                               //         },
//                               //         child: const Text(
//                               //           'Accept',
//                               //           style: TextStyle(
//                               //             color: Colors.white,
//                               //             fontSize: 15,
//                               //           ),
//                               //         ),
//                               //       ),
//                               //     ),
//                               //     const SizedBox(
//                               //       width: 10,
//                               //     ),
//                               //     //Ignore============================================
//                               //     Material(
//                               //       borderRadius: BorderRadius.circular(10),
//                               //       color: Colors.red,
//                               //       child: MaterialButton(
//                               //         minWidth: 50,
//                               //         height: 32,
//                               //         elevation: 3,
//                               //         onPressed: () async {
//                               //           await FirebaseFirestore.instance
//                               //               .collection('')
//                               //               .doc(data[i].id)
//                               //               .delete();
//                               //           //Navigator.of(context).pushNamed('engHome');
//                               //           // AwesomeDialog(
//                               //           //     context: context,
//                               //           //     dialogType: DialogType.warning,
//                               //           //     animType: AnimType.rightSlide,
//                               //           //     title: 'Success',
//                               //           //     desc: 'هل انت متأكد من هذه العملية',
//                               //           //     btnCancelOnPress: () {
//                               //           //       print('Cancel');
//                               //           //     },
//                               //           //     btnOkOnPress: () async {
//                               //           //       await FirebaseFirestore.instance
//                               //           //           .collection('customer')
//                               //           //           .doc(data[i].id)
//                               //           //           .delete();
//                               //           //       Navigator.of(context)
//                               //           //           .pushReplacementNamed('engHome');
//                               //           //     }).show();
//                               //         },
//                               //         child: const Text(
//                               //           'Ignore',
//                               //           style: TextStyle(
//                               //             color: Colors.white,
//                               //             fontSize: 15,
//                               //           ),
//                               //         ),
//                               //       ),
//                               //     ),
//                               //   ],
//                               // ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               }
//             },
//           ),
//         ));

/* Material(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue,
                                child: MaterialButton(
                                  minWidth: 50,
                                  height: 32,
                                  elevation: 3,
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushReplacementNamed('chat');
                                  },
                                  child: const Text(
                                    'Accept',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              */
