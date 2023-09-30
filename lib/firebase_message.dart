import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixme_flutter/x.dart';
import 'firebase_options.dart';

enum TopicNotifications {
  waitings,
  notifications,
}

class FirebaseMessageService {
  FirebaseMessageService() {
    getPermission();
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen(
      _firebaseMessagingForegroundHandler,
    );

    //FirebaseMessaging.onMessageOpenedApp
    // .listen(FirebaseMessageService._handleMessage);
  }

  static Future<void> initial() async {
    FirebaseMessaging.instance.getInitialMessage().then(
      (RemoteMessage? initialMessage) {
        if (initialMessage != null) {
          print('when open app');
        }
      },
    );
  }

  static void initialFirebaseBackGround() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // LocalNotificationService().showNotification(
    //   id: message.hashCode,
    //   title: message.data['title'],
    //   body: message.data['body'],
    //   payLoad: message.data['type'],
    //   localNotificationChannel: message.data['type'] == 'notifications'
    //       ? LocalNotificationChannel.defaultNotification
    //       : LocalNotificationChannel.pendingMessage,
    // );
    log('-----------------------------------------');
    log('${message.data}');
    log('-----------------------------------------');
  }

  Future<void> getPermission() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
  }

  static Future<String?> getFcmToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  Future<void> _firebaseMessagingForegroundHandler(
    RemoteMessage message,
  ) async {
    log('-----------------------------------------');
    log('${message.data}');
    log('-----------------------------------------');
  }
}
