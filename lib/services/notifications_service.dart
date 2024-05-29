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
    init();
  }

  void init() async {
    await _initializeLocalNotifications();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.local);
    await requestPermissions();
    await _fetchFirebaseMessagingToken();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });

    _scheduleDailyExpenseReminder();
    _scheduleRecurringMotivationReminders();

    Timer.periodic(const Duration(seconds: 30), (timer) {
      print('Current time: ${tz.TZDateTime.now(tz.local)}');
    });

    _testImmediateNotification();

    _testImmediateScheduledNotification();
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await _localNotifications.initialize(initializationSettings);
  }

  Future<void> requestPermissions() async {
    await _requestExactAlarmPermission();
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

  Future<void> _fetchFirebaseMessagingToken() async {
    try {
      final token = await _messaging.getToken();
      print("Firebase Messaging Token: $token");
    } catch (e) {
      print("Error fetching messaging token: $e");
    }
  }

  void _showNotification(RemoteMessage message) async {
    String notificationTitle = message.notification?.title ?? "Budget Tracker Alert";
    String notificationBody = message.notification?.body ?? "You have a new notification.";

    await _storeNotification(notificationTitle, notificationBody);

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
        notificationTitle,
        notificationBody,
        platformChannelSpecifics,
        payload: message.data.toString(),
      );
    } catch (e) {
      print("Error showing notification: $e");
    }
  }

  void sendBudgetThresholdAlert(Budget budget, double percentage) {
    String formattedPercentage = percentage.toStringAsFixed(2);
    String title = "Budget Alert";
    String body = "Warning: You have spent $formattedPercentage% of your allocated budget for '${budget.budgetName}' this month.";

    _showLocalNotification(title, body);
    _storeNotification(title, body);
  }

  void sendExpenseReminder() {
    String title = "Expense Reminder";
    String body = "Reminder: Don't forget to log your expenses for today.";

    _showLocalNotification(title, body);
    _storeNotification(title, body);
  }

  void sendMonthlySummaryReport() {
    String title = "Monthly Summary";
    String body = "Your monthly spending summary is ready. Check out where your money went!";

    _showLocalNotification(title, body);
    _storeNotification(title, body);
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
      print('Local notification shown: $title - $body');
    } catch (e) {
      print("Error showing local notification: $e");
    }
  }

  Future<void> _storeNotification(String title, String body) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final notification = NotificationModel(
      userId: user.uid,
      title: title,
      body: body,
      timestamp: Timestamp.now(),
    );

    try {
      await _firestore.collection('notification').add(notification.toJson());
      print('Notification stored: $title - $body');
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

    try {
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
      print('Daily reminder scheduled for: $scheduledDate');
    } catch (e) {
      print("Error scheduling daily reminder: $e");
    }
  }

  void _scheduleRecurringMotivationReminders() {
    Timer.periodic(const Duration(minutes: 2), (timer) {
      _scheduleDailyMotivationReminder("Motivation Reminder", "Small steps, big changes. Keep going!");
    });

    Timer.periodic(const Duration(minutes: 6), (timer) {
      _scheduleDailyMotivationReminder("Motivation Reminder", "Budgeting is making dreams possible!");
    });
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
    print('Scheduling daily motivation reminder at: $scheduledDate');

    try {
      await _localNotifications.zonedSchedule(
        3,
        title,
        body,
        scheduledDate,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      print('Daily motivation reminder scheduled for: $scheduledDate');
    } catch (e) {
      print("Error scheduling motivation notification: $e");
    }
  }

  tz.TZDateTime _nextInstanceOfTenPM() {
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 22, 0);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    print('Next instance of 10 PM: $scheduledDate');
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOf29th() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, 29, 22);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = tz.TZDateTime(tz.local, now.year, now.month + 1, 29, 22);
    }
    print('Next instance of 29th: $scheduledDate');
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

    try {
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
      print('Monthly reminder scheduled for: $scheduledDate');
    } catch (e) {
      print("Error scheduling monthly reminder: $e");
    }
  }

  void _testImmediateNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'test_channel',
      'Test Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    try {
      await _localNotifications.show(
        1,
        'Immediate Test Notification',
        'This is a test notification.',
        platformChannelSpecifics,
      );
      print('Immediate test notification shown');
    } catch (e) {
      print("Error showing test notification: $e");
    }
  }

  void _testImmediateScheduledNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'test_channel',
      'Test Scheduled Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    final tz.TZDateTime scheduledDate = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));
    print('Scheduling immediate test scheduled notification at: $scheduledDate');

    try {
      await _localNotifications.zonedSchedule(
        2,
        'Scheduled Test Notification',
        'This is a test scheduled notification.',
        scheduledDate,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      print('Immediate test scheduled notification scheduled for: $scheduledDate');
    } catch (e) {
      print("Error scheduling immediate test scheduled notification: $e");
    }
  }
}