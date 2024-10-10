import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sps/screens/inapp_webview_screen.dart';
import 'package:sps/screens/loading_screen.dart';
import 'package:sps/screens/notifications/futurebuilder/index_notification.dart';
import 'package:sps/screens/notifications/streambuilder/index_notification.dart';
import 'package:sps/screens/webview_screen.dart';
import 'package:sps/utils/check_permission_utils.dart';
import 'package:sps/utils/one_signal_utils.dart';
import 'package:sps/utils/sharedpreferences_utils.dart';
import 'package:panara_dialogs/panara_dialogs.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // storage utils
  final storageUtils = SharedpreferencesUtils();
  final checkPermissionUtils = CheckPermissionUtils(); // Initialize PermissionUtils
  late Timer timer;

  // initialised permission
  @override
  void initState(){
    super.initState();
    //askNotificationPermission();
    deviceInfo();
    OneSignal().promptUserForPushNotificationPermission();
    notificationPermission();
  }

  Future<void> deviceInfo() async {
    final device = storageUtils.getStorageDevice;
    print('This is device info: $device');
    print('Device null check: ${device == "null"}');

    // Check if device is null or empty
    if (device == "null" || device.isEmpty) {
      final deviceInfoPlugin = DeviceInfoPlugin();
      final deviceInfo = await deviceInfoPlugin.deviceInfo;
      final allInfo = deviceInfo.data.toString();
      print('This is device info: $allInfo');
      storageUtils.setSharedPrefsDevice = allInfo;
    }
  }


  // ask notification permission
  void askNotificationPermission() {
    // PlayerIDOneSignal
    PlayerIdOneSignal().oneSignalPlayerId();
  }

  void notificationPermission(){
    Future.delayed(const Duration(seconds: 5),(){
      PlayerIdOneSignal().switchNotification(context);
    }).then((value){
      timer = Timer.periodic(const Duration(minutes: 20), (timer) {
        (Timer t) => PlayerIdOneSignal().switchNotification(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text('Home Screen'),
        actions:[
          IconButton(
            onPressed: (){
              _showDialog();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            // const Text('Welcome to Home Screen'),
            // const SizedBox(height: 20),
            // Text('User Token: ${storageUtils.getStorageToken}'),
            // Text('User Name: ${storageUtils.getStorageUserName}'),
            // Text('User Uuid: ${storageUtils.getStorageUserUuid}'),
            ElevatedButton(
                onPressed: () {
                  Get.to(() => IndexNotificationScreenSB());
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // icon
                child: Row(
                  children: [
                    // icon
                    const Icon(Icons.notifications,
                    color: Colors.white,
                    ),
                    // space
                    const SizedBox(width: 10),
                    const Text(
                    'Notification (Stream Builder)',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                                  ),
                  ],
                )
            ),
            
            ElevatedButton(
              onPressed: () {
                Get.to(() => IndexNotificationScreenFB());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // icon
              child: Row(
                children: [
                  // icon
                  const Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                  // space
                  const SizedBox(width: 10),
                  const Text(
                    'Notification (Future Builder)',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ),

            ElevatedButton(
                    onPressed: () {
                      Get.to(() => InAppWebViewScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    // icon
                    child: Row(
                      children: [
                        // icon
                        const Icon(
                          Icons.web,
                        ),
                        // space
                        const SizedBox(width: 10),
                        const Text(
                          'In app webview',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )),

            ElevatedButton(
                    onPressed: () {
                      Get.to(() => WebViewScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    // icon
                    child: Row(
                      children: [
                        // icon
                        const Icon(
                          Icons.web,
                        ),
                        // space
                        const SizedBox(width: 10),
                        const Text(
                          'WebView Button',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              child: ListTile(
                  leading: Icon(Icons.people,
                  color: Colors.white
                  ),
                  title: Text('Hello ${storageUtils.getStorageUserName}',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Player ID: ${storageUtils.getStorageUserPlayerId}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    ],
                  ),
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  ),
            ),
            const SizedBox(height: 20),
            // Display device info
            _buildDeviceInfoCard(),
          ],),
        ),
      )
    );
  }

  Future<Map<String, dynamic>> _fetchDeviceDetails() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final androidInfo =
        await deviceInfoPlugin.androidInfo; // For Android devices

    return {
    'version.securityPatch': androidInfo.version.securityPatch,
      'version.sdkInt': androidInfo.version.sdkInt,
      'version.release': androidInfo.version.release,
      'version.previewSdkInt': androidInfo.version.previewSdkInt,
      'version.incremental': androidInfo.version.incremental,
      'version.codename': androidInfo.version.codename,
      'version.baseOS': androidInfo.version.baseOS,
      'board': androidInfo.board,
      'bootloader': androidInfo.bootloader,
      'brand': androidInfo.brand,
      'device': androidInfo.device,
      'display': androidInfo.display,
      'fingerprint': androidInfo.fingerprint,
      'hardware': androidInfo.hardware,
      'host': androidInfo.host,
      'id': androidInfo.id,
      'manufacturer': androidInfo.manufacturer,
      'model': androidInfo.model,
      'product': androidInfo.product,
      'supported32BitAbis': androidInfo.supported32BitAbis,
      'supported64BitAbis': androidInfo.supported64BitAbis,
      'supportedAbis': androidInfo.supportedAbis,
      'tags': androidInfo.tags,
      'type': androidInfo.type,
      'isPhysicalDevice': androidInfo.isPhysicalDevice,
      'systemFeatures': androidInfo.systemFeatures,
      'serialNumber': androidInfo.serialNumber,
      'isLowRamDevice': androidInfo.isLowRamDevice,
    };
  }

  Widget _buildDeviceInfoCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.phone_android, color: Colors.white),
            title: const Text(
              'Device Info',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Use SingleChildScrollView for scrolling
          SingleChildScrollView(
            child: FutureBuilder(
              future: _fetchDeviceDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  Map<String, dynamic> deviceDetails =
                      snapshot.data as Map<String, dynamic>;
                  return _buildDeviceDetailsList(deviceDetails);
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No device info available'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceDetailsList(Map<String, dynamic> deviceDetails) {
    return Column(
      children: deviceDetails.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  entry.key,
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  entry.value.toString(),
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }




  void _showDialog(){
    PanaraConfirmDialog.showAnimatedGrow(
      context,
      title: "Logout",
      message: "Are you sure you want to logout?",
      confirmButtonText: "Confirm",
      cancelButtonText: "Cancel",
      onTapCancel: () {
        Navigator.pop(context);
      },
      onTapConfirm: () {
        storageUtils.clearStorage();
        Get.offAll(() => LoadingScreen());
      },
      panaraDialogType: PanaraDialogType.warning,
    );
  }
}