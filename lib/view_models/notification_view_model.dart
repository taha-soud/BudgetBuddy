import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/notification_model.dart';
import '../models/budget_model.dart';
import '../services/notifications_service.dart';

class NotificationViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  NotificationService? _notificationService;
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;

  NotificationViewModel(this._notificationService) {
    _fetchNotifications();
  }

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;

  void updateNotificationService(NotificationService notificationService) {
    _notificationService = notificationService;
  }

  Future<void> _fetchNotifications() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final querySnapshot = await _firestore
          .collection('notification')
          .where('userId', isEqualTo: user.uid)
          .orderBy('timestamp', descending: true)
          .get();

      _notifications = querySnapshot.docs.map((doc) => NotificationModel.fromJson(doc.data())).toList();
    } catch (e) {
      print("Error fetching notifications: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void checkAndSendBudgetThresholdAlert(Budget budget) {
    if (_notificationService == null) return;

    double spentPercentage = ((budget.totalBudget - budget.totalRemaining) / budget.totalBudget) * 100;
    if (spentPercentage >= 90) {
      _notificationService!.sendBudgetThresholdAlert(budget, spentPercentage);
    }
  }

}
