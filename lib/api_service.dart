import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sps/screens/home_screen.dart';
import 'package:sps/screens/loading_screen.dart';
import 'package:sps/utils/sharedpreferences_utils.dart';


class ApiService extends SharedpreferencesUtils {
  final baseUrl = 'https://training2024.quickcapt.cloud';

  login(
    
    String email, String password) async {

    // endpoint
    final endpoint = Uri.parse('$baseUrl/api/login');
    // headers
    final header = {
      'Accept': 'application/json',
    };
    final body = {
      'email': email,
      'password': password,
    };
    // request
    final response = await http.post(endpoint, headers: header, body: body);

    // response body from server
    final responseBody = json.decode(response.body);

    // response status code
    final responseCode = response.statusCode;

    debugPrint('This is reponse body: $responseBody');
    debugPrint('This is reponse status code: $responseCode');

    if (responseCode == 200) {
      // storage.setString('user_token',
      //     responseBody['token']); // save token in shared preference
      // final userToken =
      //     storage.getString('user_token'); // get token from shared preference


      // debugPrint(
      //     'This is debug token: $userToken'); // print token in debug console

      setSharedPrefsToken = responseBody['token'];
      setSharedPrefsUserName = responseBody['user']['name'];
      setSharedUserUuid = responseBody['user']['uuid'];
      

      Get.snackbar('Login', 'Successfully login',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      Get.offAll(() => LoadingScreen());

    } else if (responseCode == 401) {
      debugPrint('This is debug token: $responseBody');
      Get.snackbar('Login', 'Not authorised',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}