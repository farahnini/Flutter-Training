import 'package:flutter/material.dart';
import 'package:gradient_circular_progress_indicator/gradient_circular_progress_indicator.dart';
import 'package:intl/intl.dart';
import 'package:sps/data/api_service.dart';
import 'package:sps/screens/notifications/futurebuilder/show_notification.dart';
import 'package:timeago/timeago.dart' as timeago;

class IndexNotificationScreenFB extends StatefulWidget {
  const IndexNotificationScreenFB({super.key});

  @override
  State<IndexNotificationScreenFB> createState() => _IndexNotificationScreenFBState();
}

class _IndexNotificationScreenFBState extends State<IndexNotificationScreenFB> {
  var indexNotifcations;
  
  @override
  void initState(){
    super.initState();
    indexNotifcations = ApiService().fetchIndexNotifications();
  }

  
  

 @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow,
          title: const Text('Notification'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () async {               
                setState(() {
                  indexNotifcations = ApiService().fetchIndexNotifications();
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                _showDeleteAllConfirmationDialgo();
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
                  indexNotifcations = ApiService().fetchIndexNotifications();
                });
          },
          backgroundColor: const Color.fromARGB(255, 124, 207, 255),
          child: FutureBuilder(
              future:  indexNotifcations,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GradientCircularProgressIndicator(
                          progress:
                              0.75, // Specify the progress value between 0 and 1
                          gradient: LinearGradient(
                            colors: [Colors.blue, Colors.green],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          backgroundColor:
                              Colors.grey, // Specify the background color
                          child: Text('Loading.....'), // Optional child widget
                        )
                      ],
                    ),
                  );
                } else if (snapshot.hasData) {
                  final indexNotification = snapshot.data;
                  return ListView.builder(
                    itemCount: indexNotification.length,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(8.0),
                        decoration: indexNotification[index]['read_at'] == null
                            ? BoxDecoration(
                                color: const Color.fromARGB(255, 124, 207, 255),
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10.0),
                              )
                            : BoxDecoration(
                                color: const Color.fromARGB(255, 207, 207, 207),
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SingleNotificationScreenFB(
                                        notificationId: indexNotification[index]
                                                ['id']
                                            .toString()),
                              ),
                            );
                          },
                          leading: indexNotification[index]['read_at'] == null
                              ? Icon(
                                  Icons.notifications,
                                  color: Colors.blue,
                                )
                              : Icon(
                                  Icons.notifications,
                                  color: const Color.fromARGB(255, 26, 26, 26),
                                ),
                          title: Text(
                            indexNotification[index]['data']['message'].toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: indexNotification[index]['read_at'] == null
                                  ? Colors.black
                                  : const Color.fromARGB(255, 122, 120, 120),
                            ),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('yyyy-MM-dd hh:mm:ss').format(
                                  DateTime.parse(indexNotification[index]
                                          ['created_at']
                                      .toString()),
                                ),
                              ),
                              // timeago
                              Text(
                                timeago.format(
                                  DateTime.parse(indexNotification[index]
                                          ['created_at']
                                      .toString()),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Please try again later');
                } else {
                  return Text('No notification found at the moment');
                }
              }),
        ));
  }

  // _showDeleteAllConfirmationDialgo
  void _showDeleteAllConfirmationDialgo() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete All Notification'),
            content:
                const Text('Are you sure you want to delete all notification?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  await ApiService().deleteAllNotification();
                  Navigator.of(context).pop();
                },
                child: const Text('Delete'),
              ),
            ],
          );
        });
  }
}