// import 'package:admin/features/Categories/categories.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';

// class AdminDashboard extends StatefulWidget {
//   const AdminDashboard({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _AdminDashboardState createState() => _AdminDashboardState();
// }

// class _AdminDashboardState extends State<AdminDashboard> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
//   // Dashboard statistics
//   Map<String, dynamic> stats = {
//     'totalEarnings': 0,
//     'totalBookings': 0,
//     'savedBookings': 0,
//     'newCustomers': 0,
//   };

//   List<Map<String, dynamic>> recentTransactions = [];

//   @override
//   void initState() {
//     super.initState();
//     loadDashboardData();
//   }

//   Future<void> loadDashboardData() async {
//     try {
//       // Load statistics
//       final bookingsSnapshot = await _firestore.collection('bookings').get();
//       final customersSnapshot = await _firestore.collection('customers')
//           .where('createdAt', isGreaterThan: DateTime.now().subtract(Duration(days: 1)))
//           .get();

//       // Calculate statistics
//       double totalEarnings = 0;
//       bookingsSnapshot.docs.forEach((doc) {
//         totalEarnings += (doc.data()['amount'] ?? 0).toDouble();
//       });

//       setState(() {
//         stats = {
//           'totalEarnings': totalEarnings,
//           'totalBookings': bookingsSnapshot.docs.length,
//           'savedBookings': bookingsSnapshot.docs.where((doc) => doc.data()['saved'] == true).length,
//           'newCustomers': customersSnapshot.docs.length,
//         };
//       });

//       // Load recent transactions
//       final transactionsSnapshot = await _firestore.collection('bookings')
//           .orderBy('date', descending: true)
//           .limit(10)
//           .get();

//       setState(() {
//         recentTransactions = transactionsSnapshot.docs
//             .map((doc) => doc.data())
//             .toList();
//       });
//     } catch (e) {
//       print('Error loading dashboard data: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         children: [
//           // Sidebar
//           Container(
//             width: 250,
//             color: Colors.grey[100],
//             child: Column(
//               children: [
//                 // Logo
//                 Padding(
//                   padding: EdgeInsets.all(20),
//                   child: Image.asset('assets/images/Abban Services Logo .png', height: 60),
//                 ),
                
//                 // Navigation Items
//                 _buildNavItem(Icons.dashboard, 'Dashboard', true),
//                 _buildNavItem(Icons.category, 'Categories', false),
//                 _buildNavItem(Icons.book_online, 'Booking', false),
//                 _buildNavItem(Icons.star, 'Reviews', false),
//                 _buildNavItem(Icons.people, 'Users', false),
                
//                 Divider(),
//                 Text('OTHERS', style: TextStyle(color: Colors.grey)),
                
//                 _buildNavItem(Icons.settings, 'Settings', false),
//                 _buildNavItem(Icons.logout, 'Log Out', false),
//               ],
//             ),
//           ),
          
//           // Main Content
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Today's Highlights",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 20),
                  
//                   // Statistics Cards
//                   Row(
//                     children: [
//                       _buildStatCard(
//                         'Total Earnings',
//                         '${stats['totalEarnings']}',
//                         Colors.orange[100]!,
//                         '+6% from yesterday',
//                       ),
//                       _buildStatCard(
//                         'Total Booking',
//                         '${stats['totalBookings']}',
//                         Colors.yellow[100]!,
//                         '+5% from yesterday',
//                       ),
//                       _buildStatCard(
//                         'Saved Booking',
//                         '${stats['savedBookings']}',
//                         Colors.grey[200]!,
//                         '+1.2% from yesterday',
//                       ),
//                       _buildStatCard(
//                         'New Customers',
//                         '${stats['newCustomers']}',
//                         Colors.grey[300]!,
//                         '+3.1% from yesterday',
//                       ),
//                     ],
//                   ),
                  
//                   SizedBox(height: 30),
//                   Text(
//                     'Last 10 Transactions',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 20),
                  
//                   // Transactions Table
//                   Expanded(
//                     child: Card(
//                       child: ListView(
//                         children: [
//                           DataTable(
//                             columns: [
//                               DataColumn(label: Text('Users Name')),
//                               DataColumn(label: Text('Category')),
//                               DataColumn(label: Text('Rating')),
//                               DataColumn(label: Text('Location')),
//                               DataColumn(label: Text('Status')),
//                               DataColumn(label: Text('Date')),
//                             ],
//                             rows: recentTransactions.map((transaction) {
//                               return DataRow(
//                                 cells: [
//                                   DataCell(Row(
//                                     children: [
//                                       CircleAvatar(
//                                         backgroundImage: NetworkImage(
//                                           transaction['userImage'] ?? '',
//                                         ),
//                                       ),
//                                       SizedBox(width: 8),
//                                       Text(transaction['userName'] ?? ''),
//                                     ],
//                                   )),
//                                   DataCell(Text(transaction['category'] ?? '')),
//                                   DataCell(Text('${transaction['rating'] ?? ''}')),
//                                   DataCell(Text(transaction['location'] ?? '')),
//                                   DataCell(
//                                     Container(
//                                       padding: EdgeInsets.symmetric(
//                                         horizontal: 8,
//                                         vertical: 4,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: Colors.green[100],
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                       child: Text(
//                                         transaction['status'] ?? '',
//                                         style: TextStyle(color: Colors.green),
//                                       ),
//                                     ),
//                                   ),
//                                   DataCell(Text(DateFormat('dd-MM-yyyy')
//                                       .format(transaction['date'].toDate()))),
//                                 ],
//                               );
//                             }).toList(),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   void _handleNavigation(String route) {
//     switch (route) {
//       case 'Categories':
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => CategoriesScreen()),
//         );
//         break;
//       // Add other cases for different routes
//     }
//   }
//   Widget _buildNavItem(IconData icon, String title, bool isSelected) {
//     return ListTile(
//       leading: Icon(icon, color: isSelected ? Colors.red : Colors.grey),
//       title: Text(
//         title,
//         style: TextStyle(
//           color: isSelected ? Colors.red : Colors.black,
//           fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//         ),
//       ),
//       selected: isSelected,
//             onTap: () => _handleNavigation(title), 
//     );
//   }

//   Widget _buildStatCard(String title, String value, Color color, String change) {
//     return Expanded(
//       child: Card(
//         color: color,
//         child: Padding(
//           padding: EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   color: Colors.grey[700],
//                   fontSize: 14,
//                 ),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 4),
//               Text(
//                 change,
//                 style: TextStyle(
//                   color: Colors.grey[600],
//                   fontSize: 12,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }