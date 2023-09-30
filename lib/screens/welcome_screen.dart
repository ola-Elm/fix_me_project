import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixme_flutter/widget/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class WelcomeScreen extends StatefulWidget {
  static const String screenRoute = 'welcom_screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome!',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: Color(0xff2e386b),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Are you:',
              style: TextStyle(
                fontSize: 30,
                color: Color(0xff2e386b),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            MyButton(
              color: Colors.yellow[900]!,
              onPreased: () {
                Navigator.of(context).pushNamed('engHome');
              },
              title: 'Engineer',
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'OR',
              style: TextStyle(
                fontSize: 30,
                color: Color(0xff2e386b),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            MyButton(
              color: Colors.blue,
              onPreased: () {
                Navigator.of(context).pushNamed('home');
              },
              title: 'Customer',
            ),
          ],
        ),
      ),
    );
  }
}
