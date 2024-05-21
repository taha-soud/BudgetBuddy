import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';


class CategoryService {
  final CollectionReference _categoriesCollection = FirebaseFirestore.instance.collection('category');


  Future<Category?> getCategoryById(String id) async {
    final docSnapshot = await _categoriesCollection.doc(id).get();
    if (docSnapshot.exists) {
      return Category.fromJson(docSnapshot.data() as Map<String, dynamic>);
    }
    return null;
  }


  Future<List<Category>> getCategoriesByUserId(String userId) async {
    final querySnapshot = await _categoriesCollection.where('userId', isEqualTo: userId).get();
    return querySnapshot.docs.map((doc) => Category.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }


  Future<List<Category>> getCategoriesByType(String type, {String? userId}) async {
    Query query = _categoriesCollection.where('type', isEqualTo: type);

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    final QuerySnapshot querySnapshot = await query.get();
    return querySnapshot.docs.map((doc) => Category.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> addCategory(Category category) async {
    try {
      await _categoriesCollection.doc(category.id).set(category.toJson());
    } catch (e) {
      throw Exception('Failed to add category: $e');
    }
  }
}
