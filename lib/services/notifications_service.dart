import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';



class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  NotificationService() {
    _init();
  }

  void _init() {
    _messaging.requestPermission();
    _messaging.getToken().then((token) {
      print("Firebase Messaging Token: $token");
    });

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    _localNotifications.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });
  }

  void _showNotification(RemoteMessage message) async {
    String notificationTitle = message.notification?.title ?? "Budget Tracker Alert";
    String notificationBody = message.notification?.body ?? "You have a new notification.";

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'default_channel',
      'DefaultDefault channel for notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await _localNotifications.show(
      0,
      notificationTitle,
      notificationBody,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  void sendBudgetThresholdAlert(String category, double percentage) {
    _showLocalNotification(
        "Budget Alert",
        "Warning: You have spent $percentage% of your allocated budget for '$category' this month."
    );
  }

  void sendExpenseReminder() {
    _showLocalNotification(
        "Expense Reminder",
        "Reminder: Don't forget to log your expenses for today."
    );
  }

  void sendMonthlySummaryReport() {
    _showLocalNotification(
        "Monthly Summary",
        "Your monthly spending summary is ready. Check out where your money went!"
    );
  }



  void _showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'budget_tracker_channel',
      'Budget Tracker Notifications for budget tracker app',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await _localNotifications.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
}
