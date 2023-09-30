import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixme_flutter/firebase_message.dart';
import 'package:fixme_flutter/user.dart';
import 'package:fixme_flutter/widget/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class RegisterScreen extends StatefulWidget {
  Future<String?> getFcmToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  // static const String screenRoute = 'register_screen';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController myname = TextEditingController();
  TextEditingController myemail = TextEditingController();
  TextEditingController mypassword = TextEditingController();

  // final String? token = FirebaseMessaging.instance.getToken() as String?;

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  signUp() async {
    var fromdata = formState.currentState;
    if (fromdata!.validate()) {
      fromdata.save();
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: myemail.text,
          password: mypassword.text,
        );
        return userCredential;
        // FirebaseAuth.instance.currentUser!.sendEmailVerification();
        // Navigator.of(context).pushReplacementNamed('login');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Navigator.of(context).pop();
          print('The password provided is too weak.');
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Error',
            desc: 'The password provided is too weak.',
          ).show();
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Error',
            desc: 'The account already exists for that email.',
          ).show();
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: formState,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Color(0xff2e386b),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    'Username',
                  ),
                  Container(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (val) {
                      if (val == "") {
                        return " Can't to be Empty ";
                      }
                    },
                    controller: myname,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      hintText: 'Enter your name',
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
                  const Text(
                    'Email',
                  ),
                  Container(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (val) {
                      if (val == "") {
                        return " Can't to be Empty ";
                      }
                    },
                    controller: myemail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
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
                  const Text(
                    'Password',
                  ),
                  Container(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (val) {
                      if (val == "") {
                        return " Can't to be Empty ";
                      }
                    },
                    controller: mypassword,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter your password',
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
                  const SizedBox(
                    height: 20,
                  ),
                  MyButton(
                    color: Colors.blue[800]!,
                    title: 'Register',
                    onPreased: () async {
                      UserCredential response = await signUp();
                      print('==========');
                      if (response != null) {
                        // await FirebaseFirestore.instance
                        //     .collection('users')
                        //     .doc(response.user!.uid)
                        //     .set({
                        //   'uid': response.user!.uid,
                        //   'username': myname.text,
                        //   'email': myemail.text,
                        // });
                        var fcmToken =
                            await FirebaseMessageService.getFcmToken();
                        UserClass user = UserClass(
                          username: myname.text,
                          email: myemail.text,
                          fcmToken: fcmToken ?? '',
                          userId: FirebaseAuth.instance.currentUser!.uid,
                        );

                        await FirebaseFirestore.instance
                            .collection('users')
                            .add(user.toMap());
                        Navigator.of(context).pushReplacementNamed('welcome');
                      } else {
                        print('Sign Up Failed');
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Have an account ?!  ',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed('login');
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
