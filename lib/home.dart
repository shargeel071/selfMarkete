import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String mToken ='';


  @override
  void initState() {
    super.initState();
    // var response = Provider.of<AuthProvider>(context,listen: false).checkLoggedIn();
    // print('reponse $response');
    //  Timer(const Duration(seconds: 3),
    //          (){
    //  if(response == true){
    // navigations.openWelcomeScreen(context);
    // }else{
    //   navigations.openHome(context);
    // }

    //         }
    // );
    getToken();
    requestPermission();
    initInfo();
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token){
      print('fcm token $token');
      setState(() {
        mToken = token!;
      });
    });
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void requestPermission()async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print('user granted permission');
    }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print('user granted provisional permission');
    }else{
      print('user declined permission');
    }
  }

  initInfo()async{
    var androidInitialize = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitialize = const IOSInitializationSettings();
    var initializationSettings = InitializationSettings(android: androidInitialize, iOS: iosInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String? payload)async{
      try{
        if(payload != null && payload.isNotEmpty){

        }else{

        }
      }catch(e){

      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails('12132', 'wemeet', importance: Importance.high,priority: Priority.high,playSound: true);
        NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails,iOS: const IOSNotificationDetails());
        await flutterLocalNotificationsPlugin.show(0, message.notification?.title, message.notification?.body, notificationDetails,payload: message.data['title']);
      }
    });

  }

  sendPushNotification()async{
    try{
      var res =await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: <String, String>{
        'Content-Type':'application/json',
        'Authorization':'key=AAAATlKS8D4:APA91bH-QPtcM7oH5plxvnePZB5brS_ll_76onhk5SPWgU6oanso-0E37oh7CvqORCCWT4GZxbITgKBAsuRH11dpC451a5Aezv5BFt1VtZqSVRtZmA8Ht2OzFvMA8QTDwN781Js-h0mV'
      },
        body: jsonEncode(
          <String,dynamic>{
            'priority':'high',
            'data':<String, dynamic>{
              'clicl_action':'FLUTTER_NOTIFICATION_CLICK',
              'status':'done',
              'body':'This is test notification',
              'title':'Social test'
            },

            'notification':<String, dynamic>{
              'title':'SelfMarketeApp Notification',
              'body':'This is test notification',
              'android_channel_id':'123',
            },
            'to':mToken
          }
        )
      );

      print('respnse ${res.statusCode}');
      print('respnse ${res.body}');
    }catch(error){
      print('catch error send push');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Social Login'),
        centerTitle: true,
        // actions: [
        //   TextButton(
        //       onPressed: (){
        //        //Authentication().signOut(context: context);
        //       },
        //       child: Text('Sign Out',style: TextStyle(color: Colors.white),))
        // ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              // side: BorderSide(color: Colors.red)
                            )
                        )
                    ),
                    onPressed: () async {
                      //sendPushNotification();
                      print('token ${mToken}');
                      Map map = {
                        'token': mToken
                      };
                      var res = await http.post(Uri.parse('https://4dc0-119-152-136-49.ngrok.io/auth/notification'),
                      body: jsonEncode(map)
                      );

                      print('status code ${res.statusCode}');
                      print('body ${res.body}');

                    },
                    child: Center(child: Text("Push Notification", style: TextStyle(color: Colors.white)))
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
