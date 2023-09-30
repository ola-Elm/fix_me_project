import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixme_flutter/widget/my_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  // static const String screenRoute = 'Login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  getToken() async {
    String? myToken = await FirebaseMessaging.instance.getToken();
    print('===========zvxzvdxfb=================');
    print(myToken);
  }

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: formState,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Login',
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
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          // onChanged: (value) {
                          //   email = value;
                          // },
                          decoration: const InputDecoration(
                            hintText: 'Enter your email',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.orange,
                                width: 1,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 2,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
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
                          controller: password,
                          obscureText: true,
                          // onChanged: (value) {
                          //   password = value;
                          // },
                          decoration: const InputDecoration(
                            hintText: 'Enter your password',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.orange,
                                width: 1,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 2,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            if (email.text == "") {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Forget Password',
                                desc:
                                    'الرجاء ادخال البريد الالكتروني و كلمة السر',
                              ).show();
                              return;
                            }

                            try {
                              isLoading = true;
                              setState(() {});
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: email.text);

                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.rightSlide,
                                title: 'Success',
                                desc:
                                    'تم ارسال لينك اعادة تعيين كلمة المرور الى بريدك الالكتروني الرجاء التوجه اليه',
                              ).show();
                            } catch (e) {
                              isLoading = false;
                              setState(() {});
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: 'الرجاء التاكد من البريد الالكتروني',
                              ).show();
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                              top: 10,
                              bottom: 20,
                            ),
                            child: const Text(
                              'Forget Password ?',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        MyButton(
                          color: Colors.blue,
                          title: 'Login',
                          onPreased: () async {
                            if (formState.currentState!.validate()) {
                              try {
                                isLoading = true;
                                setState(() {});
                                final credential = await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: email.text,
                                  password: password.text,
                                );
                                Navigator.of(context)
                                    .pushReplacementNamed('welcome');
                                // isLoading = false;
                                // setState(() {});
                                // if (credential.user!.emailVerified) {
                                //   Navigator.of(context)
                                //       .pushReplacementNamed('welcome');
                                // } else {
                                // FirebaseAuth.instance.currentUser!
                                //     .sendEmailVerification();
                                // AwesomeDialog(
                                //   context: context,
                                //   dialogType: DialogType.error,
                                //   animType: AnimType.rightSlide,
                                //   title: 'Error',
                                //   desc:
                                //       'الرجاء التوجه الي بريدك الالكتروني لتفعيل حسابك',
                                // ).show();
                                //}
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  print('No user found for that email.');
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    title: 'Error',
                                    desc: 'No user found for that email.',
                                  ).show();
                                } else if (e.code == 'wrong-password') {
                                  print(
                                      'Wrong password provided for that user.');
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    title: 'Error',
                                    desc:
                                        'Wrong password provided for that user.',
                                  ).show();
                                }
                              }
                            } else {
                              print('Not Valid');
                            }
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have an account?!  ',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushReplacementNamed('register');
                              },
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
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
