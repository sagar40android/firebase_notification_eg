import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_notification_eg/Message.dart';
import 'package:flutter/material.dart';

class FirebaseMessagingDemo extends StatefulWidget {
  @override
  _FirebaseMessagingDemoState createState() => _FirebaseMessagingDemoState();
}

class _FirebaseMessagingDemoState extends State<FirebaseMessagingDemo> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List<Message> messagesList;
  @override
  void initState() {
    super.initState();
    messagesList= new List<Message>();
    _getToken();
    _configureFirebaseListeners();
  }


  _getToken() {
    _firebaseMessaging.getToken().then((token) {
      print("Device token :=> ${token}");
    });
  }

  _configureFirebaseListeners(){

    _firebaseMessaging.configure(
      onMessage: (Map<String,dynamic> message) async{
        print("onMessage : ${message}");
        _setMessage(message);
      },
      onLaunch: (Map<String, dynamic> message) async{
        print("onMessage : ${message}");
        _setMessage(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onMessage : ${message}");
        _setMessage(message);
      }
    );

    _firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true,alert: true,badge: true));
  }

  _setMessage(Map<String,dynamic> message){
    final notification = message['notification'];
    final data = message['data'];
    final String title = notification['title'];
    final String body = notification['body'];
    String mMessage = data['message'];
    print("Title: $title, body: $body, message: $mMessage");

    setState(() {
      Message msg = Message(title, body, mMessage);
      messagesList.add(msg);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firebase Notification"),),
      body: ListView.builder(
          itemCount: messagesList == null ? 0 : messagesList.length,
          itemBuilder: (context,index){
            Message msg = messagesList[index];
            return ListTile(
              title: Text(msg.title != null ?msg.title : "No Message !!!" ,style: TextStyle(fontSize: 16.0),),
              subtitle: Text(msg.body != null ? msg.body : "No Body !!!" ,style: TextStyle(fontSize: 13.0)),
            );
          }),
    );
  }
}
