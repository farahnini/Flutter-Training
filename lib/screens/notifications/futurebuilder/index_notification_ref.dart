import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sps/data/api_service.dart';
import 'package:sps/screens/notifications/futurebuilder/show_notification.dart';
import 'package:timeago/timeago.dart' as timeago;

class IndexNotificationScreenFB extends StatefulWidget {
  const IndexNotificationScreenFB({super.key});

  @override
  State<IndexNotificationScreenFB> createState() =>
      _IndexNotificationScreenFBState();
}

class _IndexNotificationScreenFBState extends State<IndexNotificationScreenFB> {
  @override
  Widget build(BuildContext context) {
    final futureIndexNotification = ApiService().fetchIndexNotifications();
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notification Screen'),
            Text('Future Builder Method', style: TextStyle(fontSize: 15)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showDialogDelete();
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder(
          future: futureIndexNotification,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    Text('Loading...'),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              final indexNotification = snapshot.data;
              return Expanded(
                child: ListView.builder(
                  itemCount: indexNotification.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        border:
                            indexNotification[index]['read_at'] == null //unread
                                ? Border.all(color: Colors.red)
                                : Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SingleNotificationScreenFB(
                                notificationId:
                                    indexNotification[index]['id'].toString(),
                              ),
                            ),
                          );
                        },
                        leading:
                            indexNotification[index]['read_at'] == null //unread
                                ? const Icon(
                                    Icons.notifications,
                                    color: Colors.red,
                                  )
                                : const Icon(
                                    Icons.notifications,
                                    color: Colors.grey,
                                  ),
                        title: indexNotification[index]['read_at'] == null
                            ? Text(
                                indexNotification[index]['data']['message']
                                    .toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              )
                            : Text(
                                indexNotification[index]['data']['message']
                                    .toString(),
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                        subtitle: indexNotification[index]['read_at'] == null
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat('hh:mm a dd MMM yy').format(
                                        DateTime.parse(indexNotification[index]
                                                ['created_at']
                                            .toString())),
                                  ),
                                  Text(
                                    timeago.format(DateTime.parse(
                                        indexNotification[index]['created_at']
                                            .toString())),
                                  )
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat('hh:mm a dd MMM yy').format(
                                        DateTime.parse(indexNotification[index]
                                                ['created_at']
                                            .toString())),
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  Text(
                                      timeago.format(DateTime.parse(
                                          indexNotification[index]['created_at']
                                              .toString())),
                                      style: TextStyle(color: Colors.grey[600]))
                                ],
                              ),
                      ),
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return const Text('Please try again later');
            } else {
              return const Text('No notification at the moment');
            }
          },
        ),
      ),
    );
  }

  void _showDialogDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete All Message'),
          content: const Text('Are you sure you want to delete all message?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); //close dialog box
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                ApiService().deleteAllNotification();
                Navigator.of(context).pop(); //close dialog box
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
