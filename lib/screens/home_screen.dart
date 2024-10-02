import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sps/screens/loading_screen.dart';
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

  // initialised permission
  @override
  void initState(){
    super.initState();
    askNotificationPermission();
  }

  // ask notification permission
  void askNotificationPermission() {
    // PlayerIDOneSignal
    PlayerIdOneSignal().oneSignalPlayerId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            const Text('Welcome to Home Screen'),
            const SizedBox(height: 20),
            Text('User Token: ${storageUtils.getStorageToken}'),
            Text('User Name: ${storageUtils.getStorageUserName}'),
            Text('User Uuid: ${storageUtils.getStorageUserUuid}'),
            Card(
              child: ListTile(
                  leading: Icon(Icons.people),
                  title: Text('User Name: ${storageUtils.getStorageUserName}'),
                  subtitle: Text('${storageUtils.getStorageUserUuid}'),
                  tileColor: Colors.lightBlue,
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                    switch (value) {
                      case 'show':
                      // Add your show logic here
                      break;
                      case 'edit':
                      // Add your edit logic here
                      break;
                      case 'delete':
                      // Add your delete logic here
                      break;
                    }
                    },
                    itemBuilder: (BuildContext context) {
                    return {'show', 'edit', 'delete'}.map((String choice) {
                      return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                      );
                    }).toList();
                    },
                  ),
                  ),
            ),
            
          ],),
        ),
      )
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