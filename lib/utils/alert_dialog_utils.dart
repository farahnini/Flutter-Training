import 'package:flutter/material.dart';

class PopUpDialog{
  dialogNotification(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          titleTextStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black
          ),
          contentTextStyle: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black
          ),
          title: const Text(
            'Enable push notification via your device settings',
          ),
          content: const Text(
            'Push notification are currently disabled. Please enable push notification via your device settings to receive important updates',
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                side: const BorderSide(),
                padding: const EdgeInsets.symmetric(horizontal: 15),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Back',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ]

        );
      },
    );
  }
}