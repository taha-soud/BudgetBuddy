import 'package:cloud_firestore/cloud_firestore.dart';

class Notifications{
  final String userId;
  final String title;
  final String body;
  final Timestamp timestamp;

  Notifications({
    required this.userId,
    required this.title,
    required this.body,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'body': body,
      'timestamp': timestamp,
    };
  }

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      userId: json['userId'],
      title: json['title'],
      body: json['body'],
      timestamp: json['timestamp'],
    );
  }
}
