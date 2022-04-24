import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:kitchen/main.dart';
import 'package:kitchen/models/listorder.dart';
import 'package:kitchen/route/route.dart';
import 'package:kitchen/view/orders/ongoingorder_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  importance: Importance.high,
  playSound: true,
);

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('A bg message just showed up :  ${message.messageId}');
}

executeMessage(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }
}

notifHandling() {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');
  const IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (String? payload) =>
        onNotifClicked(navigatorKey, payload!),
  );

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      executeMessage(message);
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    executeMessage(message);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    executeMessage(message);
  });
}

subscribeTopic() {
  FirebaseMessaging.instance.subscribeToTopic('kitchen');
}

unSubscribeTopic() {
  FirebaseMessaging.instance.unsubscribeFromTopic('kitchen');
}

onDidReceiveLocalNotification(
  int id,
  String? title,
  String? body,
  String? payload,
) async {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title!),
      content: Text(body!),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Ok'),
          onPressed: () async {
            onNotifClicked(navigatorKey, payload!);
          },
        )
      ],
    ),
  );
}

onNotifClicked(navigatorKey, String dataJson) async {
  var data = jsonDecode(dataJson);
  String goTo = data['goTo'];

  switch (goTo.toLowerCase()) {
    case 'detail_order':
      Order dataOrder = Order.fromJson(data['data_order']);
      Navigate().nextPage(
        navigatorKey.currentContext,
        DetailOrder(dataOrder: dataOrder),
      );
      break;
  }
}

onClickNotif() async {}

sendPushNotif(
  int userId,
  String title,
  String desc,
  String goto,
) async {
  var response = await http
      .post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer key=AAAAp-W2BeM:APA91bE4QoNtgWn-LiL38O6d56JUHb_od_FvMteU1x6GtZBbwMF7bU7OcCUyC_rOg1l8VkuvSj6EZ_ZA61LCYDAFfiAg3jMKXnMaDZbARuqqXqyphRdTogJViIIouTLck_85Oyb6U-aY',
          },
          body: jsonEncode({
            'to': '/topics/javacode-$userId',
            'notification': <String, dynamic>{
              'title': title,
              'body': desc,
              'sound': 'true'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'title': title,
              'id': userId,
              'goTo': goto,
            },
          }))
      .catchError((e) {
    var tes = e;
  });
  print(response);
  return response;
}
