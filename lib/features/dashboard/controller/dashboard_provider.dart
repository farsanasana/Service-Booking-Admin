import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Dashboard statistics
  Map<String, dynamic> stats = {
    'totalEarnings': 0.0,
    'totalBookings': 0,
    'savedBookings': 0,
    'newCustomers': 0,
  };

  List<Map<String, dynamic>> recentTransactions = [];
  bool isLoading = false;

  Future<void> loadDashboardData() async {
    isLoading = true;
    notifyListeners();

    try {
      // Load bookings and customers
      final bookingsSnapshot = await _firestore.collection('bookings').get();
      final customersSnapshot = await _firestore
          .collection('customers')
          .where('createdAt', isGreaterThan: DateTime.now().subtract(Duration(days: 1)))
          .get();

      // Calculate statistics
      double totalEarnings = 0.0;
      bookingsSnapshot.docs.forEach((doc) {
        totalEarnings += (doc.data()['amount'] ?? 0).toDouble();
      });

      stats = {
        'totalEarnings': totalEarnings,
        'totalBookings': bookingsSnapshot.docs.length,
        'savedBookings': bookingsSnapshot.docs.where((doc) => doc.data()['saved'] == true).length,
        'newCustomers': customersSnapshot.docs.length,
      };

      // Load recent transactions
      final transactionsSnapshot = await _firestore
          .collection('bookings')
          .orderBy('date', descending: true)
          .limit(10)
          .get();

      recentTransactions = transactionsSnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error loading dashboard data: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
