import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:sps/screens/loading_screen.dart';
import 'package:sps/utils/sharedpreferences_utils.dart';


class ApiService extends SharedpreferencesUtils {
  final baseUrl = 'https://training2024.quickcapt.cloud';
  late SharedPreferences storage;

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


  Future fetchIndexNotifications() async {
    storage = await SharedPreferences.getInstance();  
    final headerToken = storage.getString('user_token'); // get user token from shared preference
    try{ 
      final indexNotificationUrl = Uri.parse('$baseUrl/api/notifications'); // notification endpoint
      final header = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $headerToken'
      };
      final response = await http.get(indexNotificationUrl, headers: header); // get request to fetch notifications

      if (response.statusCode == 200){
        final responseBody = json.decode(response.body)['data']; // decode response body (result)
        return responseBody;
      }else{
        Get.snackbar('Error', 'Something went wrong. Please try again',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      }

    }catch (e){
      debugPrint('This is error: $e');
    }

  }


  Future fetchSingleNotification(String notificationId) async {

    storage = await SharedPreferences.getInstance();  
    final headerToken = storage.getString('user_token'); // get user token from shared preference

    try{ 
      final singleNotificationUrl = Uri.parse('$baseUrl/api/notifications/$notificationId'); // notification endpoint
      final header = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $headerToken'
      };

      final response = await http.get(singleNotificationUrl, headers: header); // get request to fetch notifications

      if (response.statusCode == 200){
        final responseBody = json.decode(response.body)['data']; // decode response body (result)
        return responseBody;
      }else{
        Get.snackbar('Error', 'Something went wrong. Please try again',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      }

    }catch (e){
      debugPrint('This is error: $e');
    }
  }

  Future deleteSingleNotification(String notificationId) async{

    storage = await SharedPreferences.getInstance();

    final headerToken = storage.getString('user_token');

    try{

      final deleteNotificationUrl = Uri.parse('$baseUrl/api/notifications/$notificationId/delete'); 

      final header = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $headerToken'
      };

      final response = await http.get(deleteNotificationUrl,headers: header);

      final responseBody = json.decode(response.body)['message'];

      if (response.statusCode == 200){
        Get.snackbar('Success', responseBody,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error', responseBody,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      }

    } catch (e){
      Get.snackbar('Error', 'Something went wrong. Please try again',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future deleteAllNotification() async {
    storage = await SharedPreferences.getInstance();

    final headerToken = storage.getString('user_token');

    try {
      final deleteAllNotificationUrl =
          Uri.parse('$baseUrl/api/notifications/delete/all');

      final header = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $headerToken'
      };

      final response = await http.get(deleteAllNotificationUrl, headers: header);

      final responseBody = json.decode(response.body)['message'];

      if (response.statusCode == 200) {
        Get.snackbar('Success', responseBody,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error', responseBody,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong. Please try again',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}