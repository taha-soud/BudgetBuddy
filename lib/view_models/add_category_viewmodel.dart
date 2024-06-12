import 'package:budget_buddy/views/category_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';

class AddCategoryViewModel extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String categoryName = '';
  String selectedIcon = '';


  void updateCategoryName(String name) {
    categoryName = name;
    notifyListeners();
  }

  void updateSelectedIcon(String iconName) {
    selectedIcon = iconName;
    notifyListeners();
  }

  Future<void> saveCategory(BuildContext context) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    final docRef = FirebaseFirestore.instance.collection('category').doc();
    final String newCategoryId = docRef.id;


    if (currentUser != null) {
      final newCategory = Category(
        userId: currentUser.uid,
        name: categoryName,
        type: 'My Categories',
        icon: selectedIcon,
        id: newCategoryId,
      );


      await CategoryService().addCategory(newCategory);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> CategoryScreen()));

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No user is currently logged in')),
      );
    }
  }

  bool validateForm() {
    return formKey.currentState!.validate() && selectedIcon.isNotEmpty;
  }

  void saveForm() {
    formKey.currentState!.save();
  }
}
