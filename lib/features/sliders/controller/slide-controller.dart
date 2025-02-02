
import 'dart:async';
import 'package:admin/services/transtation_services.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/slider_model.dart';

class SlideController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<TransactionModel> _transactions = [];
  List<Stat> _stats = [];
  bool _isLoading = true;
  String? _error;

  List<TransactionModel> get transactions => _transactions;
  List<Stat> get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  StreamSubscription<QuerySnapshot>? _transactionSubscription;

  SlideController() {
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Subscribe to real-time updates
      _transactionSubscription?.cancel();
      _transactionSubscription = _firestore
          .collection('transactions')
          .orderBy('date', descending: true)
          .limit(50)
          .snapshots()
          .listen(
        (snapshot) {
          _transactions = snapshot.docs
              .map((doc) => TransactionModel.fromFirestore(doc))
              .toList();

          _updateStats();
          _isLoading = false;
          notifyListeners();
        },
        onError: (error) {
          _error = 'Failed to fetch transactions: $error';
          _isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _error = 'Failed to initialize dashboard: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void _updateStats() {
    // Calculate real stats based on transactions
    
    double totalEarnings = _transactions.length * 100; // Example calculation
    int totalBookings = _transactions.length;
    int savedBookings = _transactions.where((t) => t.status == 'saved').length;
    int newCustomers = _transactions
        .where((t) => t.date.isAfter(DateTime.now().subtract(const Duration(days: 1))))
        .length;

    _stats = [
      Stat(
        title: 'Total Earnings',
        value: '\$${totalEarnings.toStringAsFixed(2)}',
        change: '+6% from yesterday',
      ),
      Stat(
        title: 'Total Booking',
        value: totalBookings.toString(),
        change: '+5% from yesterday',
      ),
      Stat(
        title: 'Saved Booking',
        value: savedBookings.toString(),
        change: '+1.2% from yesterday',
      ),
      Stat(
        title: 'New Customers',
        value: newCustomers.toString(),
        change: '+3.1% from yesterday',
      ),
    ];
  }

  @override
  void dispose() {
    _transactionSubscription?.cancel();
    super.dispose();
  }
}