import 'dart:io';
import 'dart:math';
import 'package:path/path.dart' as path;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fixme_flutter/widget/my_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController name = TextEditingController();
  Reference? reference;
  late File file;
  var title, imageUrl;

  var imagePicker = ImagePicker();

  uploadImage() async {
    var img = await imagePicker.pickImage(source: ImageSource.gallery);

    if (img != null) {
      file = File(img.path);
      var nameimage = path.basename(img.path);

      // Start Upload

      var random = Random().nextInt(10000);
      nameimage = "$random$nameimage";
      reference = FirebaseStorage.instance.ref("images/$nameimage");

      // End Upload
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Success',
        desc: 'Please choose image',
      ).show();
    }
  }

  getImageName() async {
    var ref = await FirebaseStorage.instance.ref("images").listAll();
    ref.items.forEach((element) {
      print('===================');
      print(element.name);
    });
  }

  @override
  void initState() {
    getImageName();
    super.initState();
  }

  CollectionReference customer =
      FirebaseFirestore.instance.collection('customer');

  addProblem() async {
    var formdata = formState.currentState;
    if (formdata!.validate()) {
      formdata.save();
      // await reference!.putFile(file);
      // imageUrl = reference!.getDownloadURL();
      // await customer.add({
      //   "title": title,
      //   "imageUrl": imageUrl,
      //   "UserId": FirebaseAuth.instance.currentUser!.uid,
      // });

      try {
        await reference!.putFile(file);
        imageUrl = await reference!.getDownloadURL();

        await customer.add({
          "title": title,
          "imageUrl": imageUrl,
          "UserId": FirebaseAuth.instance.currentUser!.email,
        });
        const CircularProgressIndicator();
        //Navigator.of(context).pushReplacementNamed('home');
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          title: 'Success',
          desc: 'تم تقديم طلبك بنجاح ',
        ).show();
      } catch (e) {
        print("======Error $e");
      }
    }
  }

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: Padding(
          padding: const EdgeInsets.only(
            top: 8,
          ),
          child: Column(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    'chats',
                  );
                },
                icon: Icon(
                  Icons.chat_bubble_outline_sharp,
                  color: Colors.red,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
        title: const Text(
          'Home Page',
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
          ),
        ],
      ),
      body: Form(
        key: formState,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  const Text(
                    'Welcome', // user name
                    //=============================================================
                    //بدي احط اسم الشخص اللي سجل دخول
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Color(0xff2e386b),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  TextFormField(
                    onSaved: (val) {
                      title = val;
                    },
                    validator: (val) {
                      if (val == "") {
                        return " Can't to be Empty";
                      }
                    },
                    controller: name,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      hintText: 'What\'s your problem',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.orange,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    onPressed: uploadImage,
                    child: const Text(
                      'Upload Image',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyButton(
                    color: Colors.blue,
                    onPreased: () {
                      addProblem();
                    },
                    title: 'Apply',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
