// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:gradient_circular_progress_indicator/gradient_circular_progress_indicator.dart';
import 'package:intl/intl.dart';
import 'package:sps/data/api_service.dart';
import 'package:sps/data/blocs/index_notification_blocs.dart';
import 'package:sps/screens/notifications/streambuilder/show_notification.dart';
import 'package:timeago/timeago.dart' as timeago;


class IndexNotificationScreenSB extends StatefulWidget {
  const IndexNotificationScreenSB({super.key});

  @override
  State<IndexNotificationScreenSB> createState() => _IndexNotificationScreenSBState();
}

class _IndexNotificationScreenSBState extends State<IndexNotificationScreenSB> {

  @override
  void initState(){
    super.initState();
    notificationBloc.getCast();
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
            onPressed: () async{
              notificationBloc.drainStream();
              notificationBloc.getCast();
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
          onRefresh: () async{
            notificationBloc.drainStream();
            notificationBloc.getCast();
          },
          backgroundColor: const Color.fromARGB(255, 124, 207, 255
        ),
        child: StreamBuilder(
          stream: notificationBloc.subject.stream,
          builder: (context, AsyncSnapshot snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    GradientCircularProgressIndicator(
                        progress: 0.75, // Specify the progress value between 0 and 1
                        gradient: LinearGradient(
                          colors: [Colors.blue, Colors.green],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        backgroundColor: Colors.grey, // Specify the background color
                        child: Text('Loading.....'), // Optional child widget
                      )
                  ],
                  ),
                );
              }
              else if (snapshot.hasData){
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    return Container(
                      margin: EdgeInsets.all(8.0),
                      decoration: snapshot.data[index]['read_at'] == null
                      ? BoxDecoration(
                        color: const Color.fromARGB(255, 124, 207, 255),
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10.0),
                      )
                      :
                      BoxDecoration(
                        color: const Color.fromARGB(255, 207, 207, 207),
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SingleNotificationScreenSB(notificationId: snapshot.data[index]['id'].toString()),
                              ),
                            );
                        },
                        leading: snapshot.data[index]['read_at'] == null
                        ? Icon(
                          Icons.notifications,
                          color: Colors.blue,
                        )
                        : Icon(
                          Icons.notifications,
                          color: const Color.fromARGB(255, 26, 26, 26),
                        ),
                        title: Text(snapshot.data[index]['data']['message'].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: snapshot.data[index]['read_at'] ==
                                  null
                                  ? Colors.black
                                  : const Color.fromARGB(255, 122, 120, 120),
                          ),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.parse(snapshot.data[index]['created_at'].toString()),
                              ),
                            ),
                            // timeago
                            Text(
                              timeago.format(DateTime.parse(snapshot.data[index]['created_at'].toString()),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              else if (snapshot.hasError) {
                  return Text('Please try again later');
                }
              else{
                return Text('No notification found at the moment');
              }
          }
        ),
        )
    );
  }

  // _showDeleteAllConfirmationDialgo
  void _showDeleteAllConfirmationDialgo(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text('Delete All Notification'),
          content: const Text('Are you sure you want to delete all notification?'),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: (){
                  ApiService().deleteAllNotification();
                  notificationBloc.drainStream();
                  notificationBloc.getCast();
                  Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      }
    );
  }
}