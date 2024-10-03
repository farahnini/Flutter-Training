import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:sps/data/api_service.dart';
import 'package:sps/data/blocs/index_notification_blocs.dart';
import 'package:sps/data/blocs/single_notification_blocs.dart';
import 'package:timeago/timeago.dart' as timeago;

class SingleNotificationScreenSB extends StatefulWidget {
  final String notificationId;
  const SingleNotificationScreenSB({super.key, required this.notificationId});

  @override
  State<SingleNotificationScreenSB> createState() => _SingleNotificationScreenSBState();
}

class _SingleNotificationScreenSBState extends State<SingleNotificationScreenSB> {
  
  @override
  void initState() {
    super.initState();
    singleNotificationBloc.getCast(widget.notificationId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text('Show Notification'),
      actions: [
        IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: () {
          singleNotificationBloc.getCast(widget.notificationId);
        },
        ),
      ],
      ),
      body: RefreshIndicator(
          onRefresh: () async{
            singleNotificationBloc.drainStream();
            singleNotificationBloc.getCast(widget.notificationId);
          },
          backgroundColor: const Color.fromARGB(255, 124, 207, 255
        ),
        child: StreamBuilder(
        stream: singleNotificationBloc.subject,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data found'));
          } else {
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
                      SizedBox(
                        child: Image.asset('assets/new-item.gif')
                      ),
                      Divider(),
                      Text(snapshot.data['data']['message']),
                      Divider(),
                      Text(DateFormat('yyyy-MM-dd hh:mm:ss a').format(DateTime.parse(snapshot.data['created_at'].toString()),), ),
                      SizedBox(height:10),
                      Text(timeago.format(DateTime.parse(snapshot.data['created_at'].toString()),),),
                      
                    ],)
                )),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      PanaraConfirmDialog.showAnimatedGrow(
                          context,
                          title: "Delete",
                          message: "Are you sure you want to delete this message",
                          confirmButtonText: "Confirm",
                          cancelButtonText: "Cancel",
                          onTapCancel: () {
                            Navigator.pop(context);
                          },
                          onTapConfirm: () {
                            ApiService().deleteSingleNotification(widget.notificationId);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            notificationBloc.getCast();
                          },
                          panaraDialogType: PanaraDialogType.error,
                        );
                    },
                    style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.red),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                      side: BorderSide(color: Colors.red),
                      ),
                    ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // center the content
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
        }
      ),
      ),
    );
  }

  // show dialog

  
}