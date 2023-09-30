import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isLoading = true;

  List customer = [];

  CollectionReference customerref =
      FirebaseFirestore.instance.collection('customer');

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
          'Chats',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.red,
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
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () {
                              AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.warning,
                                  animType: AnimType.rightSlide,
                                  title: 'Success',
                                  desc: 'هل انت موافق على هذه العملية',
                                  btnOkOnPress: () async {
                                    // ChatClass chatClass = ChatClass(
                                    //
                                    // )
                                    // await FirebaseFirestore.instance
                                    //     .collection('chat')
                                    //     .add({
                                    //   'chatid': i.toString(),
                                    //   'createduser': FirebaseAuth
                                    //           .instance.currentUser!.email ??
                                    //       '',
                                    //   //enduser=> هو المهندس الي بعت مسج
                                    //   'enduser': customer[i]['UserId'],
                                    // });

                                    // Navigator.of(context)
                                    //     .push(MaterialPageRoute(
                                    //   builder: (context) =>
                                    //       ChatScreen(index: i.toString()),
                                    // ));
                                    Navigator.of(context)
                                        .pushReplacementNamed('chatc');
                                  }).show();
                            },
                            child: Text(
                              // ايميل المهندس
                              'new message',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
