// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sps/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController staffIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,  
              children: [
                //gif from asset name employee.gif
                Image.asset(
                  'employee.gif',
                  height: 200,
                  width: 200,
                ),
                Row(
                  children: [
                   Icon(
                      Icons.person,
                      size: 30,
                    ),
                   SizedBox(
                      width: 10,
                   ),
                   Expanded(
                     child: TextField(
                        controller: staffIdController,
                        decoration: InputDecoration(
                          hintText: 'Enter Staff Id',
                        ),
                     ),
                   ),
                  ],
                ),
                Row(
              children: [
                Icon(
                  Icons.lock,
                  size: 30,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter Password',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                print('Staff Id: ${staffIdController.text}');
                print('Password: ${passwordController.text}');

                // Get to Home Screen by using get.to
                Get.to(HomeScreen());

              },
              child: Text('Login'),
            )
            ],),
          )
        ),
      )
    );
  }
}