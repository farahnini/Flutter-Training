import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sps/utils/alert_dialog_utils.dart';
import 'package:sps/utils/sharedpreferences_utils.dart';

class PlayerIdOneSignal extends SharedpreferencesUtils {
  final appID = '2c9a02d4-cc6c-4f96-8286-c7ab6df7f167';
  Future<void> oneSignalPlayerId() async {
    OneSignal.shared.setAppId(appID);
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    // SharedPreferences sprefs = await SharedPreferences.getInstance();
    await OneSignal.shared
        .promptUserForPushNotificationPermission()
        .then((value) async {
      if (value == false) {
        await OneSignal.shared
            .promptUserForPushNotificationPermission(fallbackToSettings: true);
        OneSignal.shared.getDeviceState().then((value) => {
              setSharedUserPlayerId = value!.userId.toString(),
              // sprefs.setString('playerIdOneSignal', value!.userId.toString())
            });
        OneSignal.shared.addTrigger("prompt_ios", "true");
        OneSignal.shared.addTrigger("prompt_android", "true");
      } else {
        OneSignal.shared.setNotificationWillShowInForegroundHandler(
            (OSNotificationReceivedEvent event) {
          // Display Notification, send null to not display, send notification to display
          event.complete(event.notification);
        });
        OneSignal.shared.getDeviceState().then((value) {
          setSharedUserPlayerId = value!.userId.toString();
          // sprefs.setString('playerIdOneSignal', value!.userId.toString());
        });
      }
    });
  }

  Future<void> switchNotification(BuildContext context) async {
    bool? permissionGranted = await OneSignal.shared.promptUserForPushNotificationPermission();
    OneSignal.shared.promptUserForPushNotificationPermission().then((value) {
      if (permissionGranted == false) {
        PopUpDialog().dialogNotification(context);
      }
    });
  }
}
