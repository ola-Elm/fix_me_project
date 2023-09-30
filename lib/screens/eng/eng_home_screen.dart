import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixme_flutter/chat.dart';
import 'package:fixme_flutter/chat_screen.dart';
import 'package:fixme_flutter/firebase_message.dart';
import 'package:flutter/material.dart';

class EngHomeScreen extends StatefulWidget {
  const EngHomeScreen({Key? key}) : super(key: key);

  @override
  State<EngHomeScreen> createState() => _EngHomeScreenState();
}

class _EngHomeScreenState extends State<EngHomeScreen> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isLoading = true;

  //List users = [];
  List customer = [];

  // CollectionReference userref = FirebaseFirestore.instance.collection('users');
  CollectionReference customerref =
      FirebaseFirestore.instance.collection('customer');

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
    var responcTobody = await customerref.get();
    responcTobody.docs.forEach((element) {
      setState(() {
        customer.add(element.data());
      });
    });
    print(customer);
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
          'Requests',
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
          itemCount: customer.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 150,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                        child: Image(
                          image: NetworkImage(
                            '${customer[i]['imageUrl']}',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${customer[i]['title']}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 50),
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
                                          ChatClass chat = ChatClass(
                                            chatid: i.toString(),
                                            createduser: FirebaseAuth.instance
                                                    .currentUser!.email ??
                                                '',
                                            enduser: customer[i]['UserId'],
                                          );

                                          await FirebaseFirestore.instance
                                              .collection('chat')
                                              .add(chat.toMap());
                                          //////////////
                                          // await FirebaseFirestore.instance
                                          //     .collection('chat')
                                          //     .add({
                                          //   'chatid': i.toString(),
                                          //   'createduser': FirebaseAuth.instance
                                          //           .currentUser!.email ??
                                          //       '',
                                          //   'enduser': customer[i]['UserId'],
                                          // });

                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                ChatScreen(index: i.toString()),
                                          ));
                                          // Navigator.of(context)
                                          //     .pushReplacementNamed('chat');
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
                              SizedBox(
                                width: 10,
                              ),
                              //Ignore============================================
                              Material(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.red,
                                child: TextButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('')
                                        .doc(customer[i].id)
                                        .delete();
                                    //Navigator.of(context).pushNamed('engHome');
                                    // AwesomeDialog(
                                    //     context: context,
                                    //     dialogType: DialogType.warning,
                                    //     animType: AnimType.rightSlide,
                                    //     title: 'Success',
                                    //     desc: 'هل انت متأكد من هذه العملية',
                                    //     btnCancelOnPress: () {
                                    //       print('Cancel');
                                    //     },
                                    //     btnOkOnPress: () async {
                                    //       await FirebaseFirestore.instance
                                    //           .collection('customer')
                                    //           .doc(customer[i].id)
                                    //           .delete();
                                    //       Navigator.of(context)
                                    //           .pushReplacementNamed('engHome');
                                    //     }).show();
                                  },
                                  child: const Text(
                                    'Ignore',
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
