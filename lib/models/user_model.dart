import 'package:budget_buddy/models/budget_model.dart';

class User {
  final String id;
  final String email;
  final String username;
  final Budget budget;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.budget,
  });
}

