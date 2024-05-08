import 'package:budget_buddy/models/budget_model.dart';

class Users {
  final String id;
  final String email;
  final String username;
  final Budget? budget;

  Users({
    required this.id,
    required this.email,
    required this.username,
    this.budget,
  });

    factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      budget: Budget.fromJson(
          json['budget']), 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'budget': budget?.toJson(), 
    };
  }
}

