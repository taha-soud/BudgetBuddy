import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Transactions>> getTransactionsByUserId(String userId) async {
    final QuerySnapshot snapshot = await _firestore
        .collection('transaction')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) => Transactions.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

}
