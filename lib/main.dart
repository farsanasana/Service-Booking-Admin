import 'package:admin/features/categories/categories.dart';
import 'package:admin/features/categories/providers/category_provider.dart';
import 'package:admin/features/categories/repositories/category_repository.dart';
import 'package:admin/features/dashboard/controller/dashboard_provider.dart';
import 'package:admin/features/dashboard/view/admin_dashboard.dart';
import 'package:admin/features/sign_in/controller/auth_controller.dart';
import 'package:admin/features/sign_in/view/login_page.dart';
import 'package:admin/features/sliders/controller/slide-controller.dart';
import 'package:admin/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main()async {
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform );
  if (FirebaseAuth.instance.currentUser == null) {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      debugPrint('Error signing in anonymously: $e');
    }
  }
  runApp( MyApp(
    

  ));
}

class MyApp extends StatelessWidget {


  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
      //    Provider<GetUserProfile>.value(value: getUserProfile),
ChangeNotifierProvider(create: (_) => DashboardProvider()..loadDashboardData()),
        ChangeNotifierProvider(create: (_) => AuthModel()),
ChangeNotifierProvider(create: (_)=>SlideController()..fetchDashboardData()),
    ChangeNotifierProvider(create: (_)=>CategoryProvider(CategoryRepository(FirebaseFirestore.instance))),
          
        
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          
          '/login': (context) => LoginPage(),

          '/dashbord': (context) => AdminDashboard(),
        '/categories': (context) => CategoriesScreen(),
          
        },
      ),
    );
  }
}
