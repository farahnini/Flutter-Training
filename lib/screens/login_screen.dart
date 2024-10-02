// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sps/api_service.dart';
import 'package:sps/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,  
                  children: [
                    //gif from asset name employee.gif
                    Image.asset(
                      'assets/employee.gif',
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
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: 'Enter Office Email',
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                  onPressed: () {
                    print('Staff Id: ${emailController.text}');
                    print('Password: ${passwordController.text}');
                    ApiService().login(emailController.text, passwordController.text);
                  },
                  icon: Icon(Icons.login),
                  label: Text('Login'),
                  ),
                )
                ],),
              )
            ),
          ),
        ),
      )
    );
  }
}