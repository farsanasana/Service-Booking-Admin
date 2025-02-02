import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final String activeItem;

  const Sidebar({super.key, required this.activeItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.grey[100],
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Image.asset('assets/images/Abban Services Logo .png', height: 60),
          ),
          _buildNavItem(context, Icons.dashboard, 'Dashboard', activeItem == 'Dashboard','/dashbord'),
          _buildNavItem(context, Icons.category, 'Categories', activeItem == 'Categories', '/categories'),
          _buildNavItem(context, Icons.book_online, 'Booking', activeItem == 'Booking', '/booking'),
          _buildNavItem(context, Icons.star, 'Reviews', activeItem == 'Reviews', '/reviews'),
          _buildNavItem(context, Icons.people, 'Users', activeItem == 'Users', '/users'),
          Divider(),
          Text('OTHERS', style: TextStyle(color: Colors.grey)),
          _buildNavItem(context, Icons.settings, 'Settings', activeItem == 'Settings', '/settings'),
          _buildNavItem(context, Icons.logout, 'Log Out', false ,'/logout'),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData  icon, String title, bool isSelected,String route) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.red : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.red : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: (){
         Navigator.pushNamed(context, route);
      },
    );
  }
}
