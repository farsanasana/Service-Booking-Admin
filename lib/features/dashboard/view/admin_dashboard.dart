import 'package:admin/features/dashboard/controller/dashboard_provider.dart';
import 'package:admin/features/sliders/view/sildebar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);

    return Scaffold(
      body: Row(
        children: [
          // Sidebar
 Sidebar(activeItem: 'Dashboard'),

          // Main Content
          Expanded(
            child: dashboardProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Today's Highlights",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),

                        // Statistics Cards
                        Row(
                          children: [
                            _buildStatCard(
                              'Total Earnings',
                              '${dashboardProvider.stats['totalEarnings']}',
                              Colors.orange[100]!,
                              '+6% from yesterday',
                            ),
                            _buildStatCard(
                              'Total Bookings',
                              '${dashboardProvider.stats['totalBookings']}',
                              Colors.yellow[100]!,
                              '+5% from yesterday',
                            ),
                            _buildStatCard(
                              'Saved Bookings',
                              '${dashboardProvider.stats['savedBookings']}',
                              Colors.grey[200]!,
                              '+1.2% from yesterday',
                            ),
                            _buildStatCard(
                              'New Customers',
                              '${dashboardProvider.stats['newCustomers']}',
                              Colors.grey[300]!,
                              '+3.1% from yesterday',
                            ),
                          ],
                        ),

                        SizedBox(height: 30),
                        Text(
                          'Last 10 Transactions',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),

                        // Transactions Table
                        Expanded(
                          child: Card(
                            child: ListView(
                              children: [
                                DataTable(
                                  columns: [
                                    DataColumn(label: Text('Users Name')),
                                    DataColumn(label: Text('Category')),
                                    DataColumn(label: Text('Rating')),
                                    DataColumn(label: Text('Location')),
                                    DataColumn(label: Text('Status')),
                                    DataColumn(label: Text('Date')),
                                  ],
                                  rows: dashboardProvider.recentTransactions.map((transaction) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                transaction['userImage'] ?? '',
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Text(transaction['userName'] ?? ''),
                                          ],
                                        )),
                                        DataCell(Text(transaction['category'] ?? '')),
                                        DataCell(Text('${transaction['rating'] ?? ''}')),
                                        DataCell(Text(transaction['location'] ?? '')),
                                        DataCell(
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.green[100],
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              transaction['status'] ?? '',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ),
                                        ),
                                        DataCell(Text(DateFormat('dd-MM-yyyy')
                                            .format(transaction['date'].toDate()))),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }


  Widget _buildStatCard(String title, String value, Color color, String change) {
    return Expanded(
      child: Card(
        color: color,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                change,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
