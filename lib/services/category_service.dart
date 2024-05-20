import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Category>> getAllCategories() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('category').get();
      return snapshot.docs.map((doc) => Category.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Error fetching category: $e');
    }
  }

  Future<List<Category>> getCategoriesByType(String type) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('category')
          .where('type', isEqualTo: type)
          .get();
      return snapshot.docs.map((doc) => Category.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Error fetching categories of type $type: $e');
    }
  }

}
