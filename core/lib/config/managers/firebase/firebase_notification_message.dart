import 'dart:io';

import 'package:core/config/managers/firebase/local_notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

RemoteMessage? notificationMessagewhenappclosed;
Future<void> handlebackGroundMessage(RemoteMessage message) async {
  //to stop double call
  notificationMessagewhenappclosed = null;
//TODO remove it after testing
  // debugPrint("handlebackGroundMessage------->>>>>>>>  ");
  // debugPrint(message.notification.toString());
  // debugPrint("Title  " + "${message.notification?.title}");
  // debugPrint("body  " +"${message.notification?.body}");
  // debugPrint("payload  " + "${message.data}");
  if (message.data["_m"] != null) {
    LocalNotificationServices.showNotification(
        title: "${message.data["title"]}",
        body: "${message.data["subtitle"]}",
        payload: "${message.data}");
  } else {
    notificationMessagewhenappclosed = message;
  }
}

class FirebaseApi {
  final _firebaseMessageing = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessageing.requestPermission();
    //TODO remove it after testing
    // final fcmtoken = await _firebaseMessageing.getToken();
    // debugPrint("Token fcm-->>>  " + fcmtoken.toString());

    FirebaseMessaging.onMessage.listen((message) {
      //TODO remove it after testing
      // debugPrint("onMessage------->>>>>>>>  ");
      // debugPrint("Title  " + "${message.notification?.title}");
      // debugPrint("body  " + "${message.notification?.body}");
      // debugPrint("payload  " + "${message.data}");

      if (message.notification?.title != null &&
          message.notification?.body != null) {
        LocalNotificationServices.showNotification(
            title: "${message.notification?.title}",
            body: "${message.notification?.body}",
            payload: "${message.data}");
      } else {
        LocalNotificationServices.showNotification(
            title: "${message.data["title"]}",
            body: "${message.data["subtitle"]}",
            payload: "${message.data}");
      }
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      //TODO remove it after testing
      // debugPrint("getInitialMessage------->>>>>>>>  ");
      // debugPrint("Title  " + "${message?.notification}");
      // debugPrint("body  " + "${message?.notification?.body}");
      // debugPrint("payload  " + "${message?.data}");
      if (message?.notification != null) {
        notificationMessagewhenappclosed = message;
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      //TODO remove it after testing
      // debugPrint("onMessageOpenedApp------->>>>>>>>  ");
      // debugPrint("Title  " + "${message.notification?.title}");
      // debugPrint("body  " + "${message.notification?.body}");
      // debugPrint("payload  " + "${message.data}");
    });

    FirebaseMessaging.onBackgroundMessage(handlebackGroundMessage);
    // FirebaseMessaging.instance.getInitialMessage().then((value) => notificationMessagewhenappclosed = value);
  }
}

Future<void> firbaseNotificationinitizialiation() async {
  if (Platform.isAndroid) {
    await Firebase.initializeApp();
    await FirebaseApi().initNotification();
    await LocalNotificationServices.initnotification();
  }
}

Future handleMessageWhenAppisclosed() async {
  return notificationMessagewhenappclosed;
}
