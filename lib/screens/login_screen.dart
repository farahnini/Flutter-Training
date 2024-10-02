// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sps/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obsecureText = true;


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
                        obscureText: _obsecureText,
                        decoration: InputDecoration(
                          hintText: 'Enter Password',
                          suffixIcon: GestureDetector(
                            onTap: (){
                              setState(() {
                                _obsecureText = !_obsecureText;
                              });
                            },
                            child: Icon(
                              _obsecureText ? Icons.visibility : Icons.visibility_off,
                              size: 20,
                            ),
                          )
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
                      ApiService()
                          .login(emailController.text, passwordController.text);
                    },
                    icon: Icon(Icons.login),
                    label: Text('Login'),
                  ),
                )
              ],
            ),
          )),
        ),
      ),
    ));
  }
}
