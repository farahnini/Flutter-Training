import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:sps/data/api_service.dart';
import 'package:timeago/timeago.dart' as timeago;

class SingleNotificationScreenFB extends StatefulWidget {
  final String notificationId;
  const SingleNotificationScreenFB({super.key, required this.notificationId});

  @override
  State<SingleNotificationScreenFB> createState() =>
      _SingleNotificationScreenFBState();
}

class _SingleNotificationScreenFBState extends State<SingleNotificationScreenFB> {
  late Future<dynamic> singleNotification;

  @override
  void initState() {
    super.initState();
    singleNotification = ApiService().fetchSingleNotification(widget.notificationId);
  }

  // void to

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Show Notification'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                singleNotification =
                    ApiService().fetchSingleNotification(widget.notificationId);
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            singleNotification =
                ApiService().fetchSingleNotification(widget.notificationId);
          });
        },
        backgroundColor: const Color.fromARGB(255, 124, 207, 255),
        child: FutureBuilder(
          future: singleNotification,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('No data found'));
            } else {
              final data = snapshot.data;
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          SizedBox(child: Image.asset('assets/new-item.gif')),
                          Divider(),
                          Text(data['data']['message'] ??
                              'No message available'),
                          Divider(),
                          Text(
                            DateFormat('yyyy-MM-dd hh:mm:ss a').format(
                              DateTime.parse(data['created_at'].toString()),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            timeago.format(
                              DateTime.parse(data['created_at'].toString()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        PanaraConfirmDialog.showAnimatedGrow(
                          context,
                          title: "Delete",
                          message:
                              "Are you sure you want to delete this message",
                          confirmButtonText: "Confirm",
                          cancelButtonText: "Cancel",
                          onTapCancel: () {
                            Navigator.pop(context);
                          },
                          onTapConfirm: () async {
                            await ApiService().deleteSingleNotification(
                                widget.notificationId);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          panaraDialogType: PanaraDialogType.error,
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            side: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'Delete Message',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
