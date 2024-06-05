import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/budget_model.dart';
import '../models/notification_model.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  NotificationService() {
    tz.initializeTimeZones();
    init();
  }

  void init() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await _localNotifications.initialize(initializationSettings);
    print(tz.local);
    await requestPermissions();
    _initializeLocalNotifications();

    try {
      final token = await _messaging.getToken();
      print("Firebase Messaging Token: $token");
    } catch (e) {
      print("Error fetching messaging token: $e");
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message.notification?.title ?? "Budget Tracker Alert", message.notification?.body ?? "You have a new notification.");
    });

    _scheduleDailyExpenseReminder();
    _scheduleMonthlyReminderOn29th();

    Timer.periodic(const Duration(seconds: 120), (timer) {
      _scheduleDailyMotivationReminder("Motivation Reminder", "Small steps, big changes. Keep going!");

    });

    Timer.periodic(const Duration(seconds: 360), (timer) {
      _scheduleDailyMotivationReminder("Motivation Reminder", "Budgeting is making dreams possible!");
    });
  }

  Future<void> requestPermissions() async {
    _requestExactAlarmPermission();
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> _requestExactAlarmPermission() async {
    if (await Permission.scheduleExactAlarm.request().isGranted) {
      print("Exact alarm permission granted");
    } else {
      print("Exact alarm permission denied");
    }
  }

  void _initializeLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    _localNotifications.initialize(initializationSettings);
  }

  void _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'default_channel',
      'Default channel for notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    try {
      await _localNotifications.show(
        0,
        title,
        body,
        platformChannelSpecifics,
        payload: '', // Use payload to pass data if needed
      );
      print("Notification shown: $title - $body");

      // Store notification after it is shown
      await _storeNotification(title, body);
    } catch (e) {
      print("Error showing notification: $e");
    }
  }

  void sendBudgetThresholdAlert(Budget budget, double percentage) {
    String formattedPercentage = percentage.toStringAsFixed(2);
    String title = "Budget Alert";
    String body = "Warning: You have spent $formattedPercentage% of your allocated budget for '${budget.budgetName}' this month.";

    _showLocalNotification(title, body);
  }

  void sendExpenseReminder() {
    String title = "Expense Reminder";
    String body = "Reminder: Don't forget to log your expenses for today.";

    _showLocalNotification(title, body);
  }

  void sendMonthlySummaryReport() {
    String title = "Monthly Summary";
    String body = "Your monthly spending summary is ready. Check out where your money went!";

    _showLocalNotification(title, body);
  }

  void _showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'budget_tracker_channel',
      'Budget Tracker Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    try {
      await _localNotifications.show(
        0,
        title,
        body,
        platformChannelSpecifics,
        payload: 'item x',
      );
      print("Local notification shown: $title - $body");

      // Store notification after it is shown
      await _storeNotification(title, body);
    } catch (e) {
      print("Error showing local notification: $e");
    }
  }

  Future<void> _storeNotification(String title, String body) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final notification = Notifications(
      userId: user.uid,
      title: title,
      body: body,
      timestamp: Timestamp.now(),
    );

    try {
      await _firestore.collection('notification').add(notification.toJson());
      print("Notification stored in Firestore: $title - $body");
    } catch (e) {
      print("Error storing notification: $e");
    }
  }

  void _scheduleDailyExpenseReminder() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'daily_reminder_channel',
      'Daily Reminder Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    final tz.TZDateTime scheduledDate = _nextInstanceOfTenPM();
    print('Scheduling daily reminder at: $scheduledDate');

    await _localNotifications.zonedSchedule(
      0,
      'Expense Reminder',
      "Don't forget to log your expenses for today.",
      scheduledDate,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    // Store notification in Firestore
    await _storeNotification('Expense Reminder', "Don't forget to log your expenses for today.");
  }

  tz.TZDateTime _nextInstanceOf29th() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, 29, 22);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = tz.TZDateTime(tz.local, now.year, now.month + 1, 29, 22);
    }
    return scheduledDate;
  }

  void _scheduleMonthlyReminderOn29th() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'monthly_reminder_channel',
      'Monthly Reminder Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    final tz.TZDateTime scheduledDate = _nextInstanceOf29th();
    print('Scheduling monthly reminder at: $scheduledDate');

    await _localNotifications.zonedSchedule(
      1,
      'Monthly Summary Report',
      "Your monthly spending summary is ready. Check out where your money went!",
      scheduledDate,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
    );

    // Store notification in Firestore
    await _storeNotification('Monthly Summary Report', "Your monthly spending summary is ready. Check out where your money went!");
  }

  void _scheduleDailyMotivationReminder(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'daily_reminder_channel',
      'Daily Reminder Notifications',
      channelDescription: 'This channel is used for daily reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    final tz.TZDateTime scheduledDate = _nextInstanceOfTenPM();
    print('Scheduling daily reminder at: $scheduledDate');

    await _localNotifications.show(
      3,
      title,
      body,
      platformChannelSpecifics,

    );

    await _storeNotification(title, body);
  }

  tz.TZDateTime _nextInstanceOfTenPM() {
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 14, 47);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}