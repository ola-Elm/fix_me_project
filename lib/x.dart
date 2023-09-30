import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum LocalNotificationChannel {
  pendingMessage,
  defaultNotification,
}

class LocalNotificationService {
  static final LocalNotificationService _localNotificationService =
      LocalNotificationService._internal();
  late final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  factory LocalNotificationService() {
    return _localNotificationService;
  }

  LocalNotificationService._internal() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  }

  FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin =>
      _flutterLocalNotificationsPlugin;

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_stat_notification_white');

    DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse:
          _receiveBackgroundNotificationResponse,
      // onDidReceiveNotificationResponse: _receiveNotificationResponse,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {}

  // void _receiveNotificationResponse(NotificationResponse details) {
  //   if (!(Get.currentRoute == AppRoutes.loginPage ||
  //       Get.currentRoute == AppRoutes.verificationCodePage)) {
  //     moveToPage(details.payload);
  //   }
  // }

  notificationDetails({
    required LocalNotificationChannel localNotificationChannel,
  }) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        '${localNotificationChannel.name}ID',
        localNotificationChannel.name,
        importance: Importance.max,
        //color: AppColors.primary,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
    );
  }

  Future showNotification({
    required int id,
    String? title,
    String? body,
    String? payLoad,
    required LocalNotificationChannel localNotificationChannel,
  }) async {
    return _localNotificationService._flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      await notificationDetails(
        localNotificationChannel: localNotificationChannel,
      ),
      payload: payLoad,
    );
  }

  @pragma('vm:entry-point')
  static void _receiveBackgroundNotificationResponse(
      NotificationResponse details) {}
}
