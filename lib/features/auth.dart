import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}


// dashboard_service.dart

class DashboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getDashboardData() async {
    // Get statistics
    final bookingsSnapshot = await _firestore.collection('bookings').get();
    final customersSnapshot = await _firestore.collection('customers')
        .where('createdAt', isGreaterThan: Timestamp.fromDate(
          DateTime.now().subtract(Duration(days: 1)),
        ))
        .get();

    // Calculate totals
    double totalEarnings = 0;
    bookingsSnapshot.docs.forEach((doc) {
      totalEarnings += (doc.data()['amount'] ?? 0).toDouble();
    });

    // Get recent transactions
    final transactionsSnapshot = await _firestore.collection('bookings')
        .orderBy('date', descending: true)
        .limit(10)
        .get();

    return {
      'stats': {
        'totalEarnings': totalEarnings,
        'totalBookings': bookingsSnapshot.docs.length,
        'savedBookings': bookingsSnapshot.docs
            .where((doc) => doc.data()['saved'] == true)
            .length,
        'newCustomers': customersSnapshot.docs.length,
      },
      'transactions': transactionsSnapshot.docs
          .map((doc) => doc.data())
          .toList(),
    };
  }
}